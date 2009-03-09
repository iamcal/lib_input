<?php
	#
	# $Id$
	#
	# lib_input - A library for filtering user input
	#
	# Copyright (c) 2007-2008 Yahoo! Inc.  All rights reserved.  This library is
	# free software; you can redistribute it and/or modify it under the terms of
	# the GNU General Public License (GPL), version 2 only.  This library is
	# distributed WITHOUT ANY WARRANTY, whether express or implied. See the GNU
	# GPL for more details (http://www.gnu.org/licenses/gpl.html)
	#

	####################################################################################################

	#
	# take an input string and return a valud UTF-8 string with no
	# unexpected control characters.
	#

	function input_clean($data, $allow_lines=0, $direction = 'ltr'){

		#
		# ftp://ftp.rfc-editor.org/in-notes/rfc3454.txt, section 5 is incredibly useful here
		#
	
		#
		# non breaking space (Unicode U+00A0)
		#
		
		$data = preg_replace('/\xc2\xa0/',' ', $data);          
				
		#
		# carrige returns \r and \r\n
		# Paragraph Separator (U+2028)
		# Line Separator (U+2029)
		# Next Line (NEL) (U+0085)
		#
		
		$data = preg_replace('/(\xe2\x80[\xa8-\xa9]|\xc2\x85|\r\n|\r)/', "\n", $data); 
			
		# 
		# ascii control chars (less than 32)
		# various invisible and/or control chars (U+2060 - U+206F) (with a couple of non-valid characters in the middle)
		# unicode control chars (U+0080 - U+009F)
		# unicode control chars (U+FFF9 - U+FFFC)
		# unicode "replacement character" (U+FFFD)
		#
		# IMPORTANT - U+FFFD is, in theory, a perfectly legal character, but we've found that various systems choke on input
		# which contains it, either treating it as an "end of input" mark, or becoming confused about encoding of the whole text.
		#
		# Since it's only an "I don't know what was supposed to be here" mark, we feel fine with dropping it, but if you have
		# an application in which these marks are required, you may want to alter these lines so that U+FFFD isn't stripped out.
		#
		# (to accomplish that, change "\xEF\xBF[\xb9-\xbd]" to "\xEF\xBF[\xb9-\xbc]" on lines 60 and 62)
		#
		
		#			       ( ascii ctl chars    DEL | U+FFF9 - U+FFFD   | U+2060 - U+206F   | U+0080 - U+009F)
		if ($allow_lines){
			$data = preg_replace('/([\x00-\x09\x0b-\x1f\x7f]|\xEF\xBF[\xb9-\xbd]|\xe2\x81[\xA0-\xAF]|\xc2[\x80-\x9f])/', '', $data);
		}else{
			$data = preg_replace(         '/([\x00-\x1f\x7f]|\xEF\xBF[\xb9-\xbd]|\xe2\x81[\xA0-\xAF]|\xc2[\x80-\x9f])/', '', $data);
		}

		#
		# Balance unicode bidi markers (see http://www.iamcal.com/understanding-bidirectional-text/)
		#
		# LRE - U+202A - 0xE2 0x80 0xAA
		# RLE - U+202B - 0xE2 0x80 0xAB
		# LRO - U+202D - 0xE2 0x80 0xAD
		# RLO - U+202E - 0xE2 0x80 0xAE
		#
		# PDF - U+202C - 0xE2 0x80 0xAC
		#
		# We shouldn't need to worry about:
		#
		# LRM - U+200E
		# RLM - U+200F
		#

		$explicits	= '\xE2\x80\xAA|\xE2\x80\xAB|\xE2\x80\xAD|\xE2\x80\xAE';
		$pdf		= '\xE2\x80\xAC';

		preg_match_all("!$explicits!",	$data, $m1, PREG_OFFSET_CAPTURE | PREG_SET_ORDER);
		preg_match_all("!$pdf!", 	$data, $m2, PREG_OFFSET_CAPTURE | PREG_SET_ORDER);

		if (count($m1) || count($m2)){

			$p = array();
			foreach ($m1 as $m){ $p[$m[0][1]] = 'push'; }
			foreach ($m2 as $m){ $p[$m[0][1]] = 'pop'; }
			ksort($p);

			$offset = 0;
			$stack = 0;
			foreach ($p as $pos => $type){

				if ($type == 'push'){
					$stack++;
				}else{
					if ($stack){
						$stack--;
					}else{
						# we have a pop without a push - remove it
						$data = substr($data, 0, $pos-$offset).substr($data, $pos+3-$offset);
						$offset += 3;
					}
				}
			}

			# now add some pops if your stack is bigger than 0
			for ($i=0; $i<$stack; $i++){
				$data .= "\xE2\x80\xAC";
			}
		}

		#
		# in theory we might also want to filter out:
		#  U+06DD - ARABIC END OF AYAH
		#  U+070F - SYRIAC ABBREVIATION MARK
		#  U+180E - MONGOLIAN VOWEL SEPARATOR
		# but it doesn't look like they'll screw up the output, and someone somewhere might actually
		# use them...
		#
		
		return input_verify_utf8($data);
	}

	####################################################################################################

	#
	# this function checks that the input string contains valid UTF-8 data,
	# else we assume it's Latin1 (ISO-8859-1) and convert it to UTF-8.
	#
	# in places where we know the input encoding (like email with a charset
	# header) then we'll want to explicitly do the transcode instead of
	# letting this function mangle it.
	#

	function input_verify_utf8($data){

		if (preg_match('![\xC0-\xDF]([\x00-\x7F]|$)!s', $data)){
			return utf8_encode($data);
		}
		if (preg_match('![\xE0-\xEF].{0,1}([\x00-\x7F]|$)!s', $data)){
			return utf8_encode($data);
		}
		if (preg_match('![\xF0-\xF7].{0,2}([\x00-\x7F]|$)!s', $data)){
			return utf8_encode($data);
		}
		if (preg_match('![\xF8-\xFB].{0,3}([\x00-\x7F]|$)!s', $data)){
			return utf8_encode($data);
		}
		if (preg_match('![\xFC-\xFD].{0,4}([\x00-\x7F]|$)!s', $data)){
			return utf8_encode($data);
		}
		if (preg_match('![\xFE-\xFE].{0,5}([\x00-\x7F]|$)!s', $data)){
			return utf8_encode($data);
		}
		if (preg_match('![\x00-\x7F][\x80-\xBF]!', $data)){
			return utf8_encode($data);
		}
		if (preg_match('!\xFF!', $data)){
			return utf8_encode($data);
		}
		return $data;
	}

	####################################################################################################
?>
