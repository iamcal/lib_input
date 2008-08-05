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

	function input_clean($data, $allow_lines=0){

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
		#
		
		#			       ( ascii ctl chars    DEL | U+FFF9 - U+FFFC   | U+2060 - U+206F   | U+0080 - U+009F)
		if ($allow_lines){
			$data = preg_replace('/([\x00-\x09\x0b-\x1f\x7f]|\xEF\xBF[\xb9-\xbc]|\xe2\x81[\xA0-\xAF]|\xc2[\x80-\x9f])/', '', $data);
		}else{
			$data = preg_replace(         '/([\x00-\x1f\x7f]|\xEF\xBF[\xb9-\xbc]|\xe2\x81[\xA0-\xAF]|\xc2[\x80-\x9f])/', '', $data);
		}

		# RIGHT TO LEFT MARKS (U+200F and U+200E)
		# We need to close these off (ie, add a LTR mark) to any user-input text
		# So that their text doesn't then reverse the word-order of every sentence
		# output after it...
		#
		# This DOES NOT balance LTR characters because we're currently a LTR-only site
		# and in all honesty, the chances of us branching into RTL languages are 
		# pretty remote right now. If we ever did support RTL languages in the interface,
		# it would probably be simpler to bracket each in-site translation with 
		# [RTL][string][LTR] than to play with filtering here.
		
		$rtl_pairs = array(	"\xe2\x80\x8f" => "\xe2\x80\x8e",
					"\xe2\x80\xae" => "\xe2\x80\xad",
				);

		foreach ($rtl_pairs as $rtl => $ltr){
			if (preg_match("/$rtl/", $data)){
				$fragments = explode($rtl, $data);
				if (!preg_match("/$ltr/", $fragments[count($fragments)-1])){
					$data .= $ltr;
				}
			}
		}

		# in theory we might also want to filter out:
		#  U+06DD - ARABIC END OF AYAH
		#  U+070F - SYRIAC ABBREVIATION MARK
		#  U+180E - MONGOLIAN VOWEL SEPARATOR
		# but it doesn't look like they'll screw up the output, and someone somewhere might actually
		# use them...

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
