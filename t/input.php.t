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

	include('Flickr/Test/Straps.php');
	include('lib_input.php');

	plan(160);

	ok( 1, "parsed libraries");
	
	#
	# input_clean 
	#
	ok( "basic input" == input_clean("basic input"),"basic input");
	
	isnt( "1",input_clean("2"),"sanity check");

	# line breaks
	
	is( "1      ",          input_clean("1 \n \r \r\n \xe2\x80\xa8 \xe2\x80\xa9 \xc2\x85"),"strip line breaks");
	is( "1 \n \n \n \n \n \n",input_clean("1 \n \r \r\n \xe2\x80\xa8 \xe2\x80\xa9 \xc2\x85",1),"don't strip line breaks");

	# ascii control chars
	
	for($i=0;$i<32;$i++) {
		$chr = chr($i);
		is("!!", input_clean("!$chr!"),"strip ascii $i");
		if (!in_array($chr,array("\n","\r"))) {
			is("!!", input_clean("!$chr!", 1),"strip ascii $i");
			
		}
	}
	
	is("! !", input_clean("! !"),"don't strip ascii 32 space (control char boundary)");	
	is( "!\x7E!", input_clean("!\x7E!"), "don't strip U+00&e (next to delete)");
	
	is( "!!",     input_clean("!\x7F!"), "strip U+007F (delete)");
	
	# control chars U+0080 - U+009F
	is( "!!",input_clean("!\xc2\x80!",0),"strip unicode U+0080");
	is( "!!",input_clean("!\xc2\x81!",0),"strip unicode U+0081");
	is( "!!",input_clean("!\xc2\x82!",0),"strip unicode U+0082");
	is( "!!",input_clean("!\xc2\x83!",0),"strip unicode U+0083");
	is( "!!",input_clean("!\xc2\x84!",0),"strip unicode U+0084");
	is( "!!",input_clean("!\xc2\x86!",0),"strip unicode U+0086");
	is( "!!",input_clean("!\xc2\x87!",0),"strip unicode U+0087");
	is( "!!",input_clean("!\xc2\x88!",0),"strip unicode U+0088");
	is( "!!",input_clean("!\xc2\x89!",0),"strip unicode U+0089");
	is( "!!",input_clean("!\xc2\x8A!",0),"strip unicode U+008A");
	is( "!!",input_clean("!\xc2\x8B!",0),"strip unicode U+008B");
	is( "!!",input_clean("!\xc2\x8C!",0),"strip unicode U+008C");
	is( "!!",input_clean("!\xc2\x8D!",0),"strip unicode U+008D");
	is( "!!",input_clean("!\xc2\x8E!",0),"strip unicode U+008E");
	is( "!!",input_clean("!\xc2\x8F!",0),"strip unicode U+008F");
	is( "!!",input_clean("!\xc2\x90!",0),"strip unicode U+0090");
	is( "!!",input_clean("!\xc2\x91!",0),"strip unicode U+0091");
	is( "!!",input_clean("!\xc2\x92!",0),"strip unicode U+0092");
	is( "!!",input_clean("!\xc2\x93!",0),"strip unicode U+0093");
	is( "!!",input_clean("!\xc2\x94!",0),"strip unicode U+0094");
	is( "!!",input_clean("!\xc2\x95!",0),"strip unicode U+0095");
	is( "!!",input_clean("!\xc2\x96!",0),"strip unicode U+0096");
	is( "!!",input_clean("!\xc2\x97!",0),"strip unicode U+0097");
	is( "!!",input_clean("!\xc2\x98!",0),"strip unicode U+0098");
	is( "!!",input_clean("!\xc2\x99!",0),"strip unicode U+0099");
	is( "!!",input_clean("!\xc2\x9A!",0),"strip unicode U+009A");
	is( "!!",input_clean("!\xc2\x9B!",0),"strip unicode U+009B");
	is( "!!",input_clean("!\xc2\x9C!",0),"strip unicode U+009C");
	is( "!!",input_clean("!\xc2\x9D!",0),"strip unicode U+009D");
	is( "!!",input_clean("!\xc2\x9E!",0),"strip unicode U+009E");
	is( "!!",input_clean("!\xc2\x9F!",0),"strip unicode U+009F");
	
	# non breaking space
	
	is( "! !",input_clean("!\xc2\xa0!",1),"strip unicode non breaking spaces U+00A0");
	is( "! !",input_clean("!\xc2\xa0!",0),"strip unicode non breaking spaces U+00A0");
	
	is( "!\xc2\xa1!",input_clean("!\xc2\xa1!",0),"don't strip U+00A1 (boundary)");
	
	# U+2060 - U+206F 
	is( "!\xe2\x81\x9f!",input_clean("!\xe2\x81\x9f!",0),"don't strip unicode U+205F (boundary)");
	is( "!!",input_clean("!\xe2\x81\xa0!",0),"strip unicode U+2060");
	is( "!!",input_clean("!\xe2\x81\xa1!",0),"strip unicode U+2061");
	is( "!!",input_clean("!\xe2\x81\xa2!",0),"strip unicode U+2062");
	is( "!!",input_clean("!\xe2\x81\xa3!",0),"strip unicode U+2063");
	is( "!!",input_clean("!\xe2\x81\xa4!",0),"strip unicode U+2064");
	is( "!!",input_clean("!\xe2\x81\xa5!",0),"strip unicode U+2065");
	is( "!!",input_clean("!\xe2\x81\xa6!",0),"strip unicode U+2066");
	is( "!!",input_clean("!\xe2\x81\xa7!",0),"strip unicode U+2067");
	is( "!!",input_clean("!\xe2\x81\xa8!",0),"strip unicode U+2068");
	is( "!!",input_clean("!\xe2\x81\xa9!",0),"strip unicode U+2069");
	is( "!!",input_clean("!\xe2\x81\xaa!",0),"strip unicode U+206A");
	is( "!!",input_clean("!\xe2\x81\xab!",0),"strip unicode U+206B");
	is( "!!",input_clean("!\xe2\x81\xac!",0),"strip unicode U+206C");
	is( "!!",input_clean("!\xe2\x81\xad!",0),"strip unicode U+206D");
	is( "!!",input_clean("!\xe2\x81\xae!",0),"strip unicode U+206E");
	is( "!!",input_clean("!\xe2\x81\xaf!",0),"strip unicode U+206F");
	is( "!\xe2\x81\xb0!",input_clean("!\xe2\x81\xb0!",0),"don't strip unicode U+2070 (boundary)");
	
	# U+FFF9 - FFFC
	is( "!\xef\xbf\xb8!",input_clean("!\xef\xbf\xb8!",0),"don't strip unicode U+FFF8 (boundary)");
	is( "!!",input_clean("!\xef\xbf\xb9!",0),"strip unicode U+FFF9");
	is( "!!",input_clean("!\xef\xbf\xba!",0),"strip unicode U+FFFa");
	is( "!!",input_clean("!\xef\xbf\xbb!",0),"strip unicode U+FFFb");
	is( "!!",input_clean("!\xef\xbf\xbc!",0),"strip unicode U+FFFc");
	is( "!!",input_clean("!\xef\xbf\xbd!",0),"strip unicode U+FFFd");
	
	# Check for balanced RTL/LTR chars
	print("# NOTE: output for the next tests may look wrong due to unicode RTL chars\n");
	is( "\xe2\x80\x8fabcdef\xe2\x80\x8e",input_clean("\xe2\x80\x8fabcdef", 0),"[ltr] balance string with U+200F char but no U+200E char" );
	is( "\xe2\x80\x8fabcdef\xe2\x80\x8e",input_clean("\xe2\x80\x8fabcdef\xe2\x80\x8e", 0),"[ltr] don't touch string with balanced U+200F/U+200E chars" );
	is( "abcdef\xe2\x80\x8f\xe2\x80\x8e",input_clean("\xe2\x80\x8eabcdef\xe2\x80\x8f", 0),"[ltr] balance string with balanced U+200E then U+200F" );
	is( "\xe2\x80\x8fabc\xe2\x80\x8fdef\xe2\x80\x8e",input_clean("\xe2\x80\x8fabc\xe2\x80\x8fdef", 0),"[ltr] balance string with multiple U+200F chars but no U+200E char" );
	is( "abc\xe2\x80\x8edef",input_clean("\xe2\x80\x8eabc\xe2\x80\x8edef", 0),"[ltr] don't balance string with multiple U+200E chars but no U+200F char" );
	is( "\xe2\x80\x8fabc\xe2\x80\x8e:\xe2\x80\x8fdef\xe2\x80\x8e",input_clean("\xe2\x80\x8fabc\xe2\x80\x8e:\xe2\x80\x8fdef", 0),"[ltr] balance string with multiple U+200F chars but only one U+200E char" );
	is( "\xe2\x80\x8fabc\xe2\x80\x8e:\xe2\x80\x8fdef\xe2\x80\x8e:\xe2\x80\x8fghi\xe2\x80\x8e",input_clean("\xe2\x80\x8fabc\xe2\x80\x8e:\xe2\x80\x8fdef\xe2\x80\x8e:\xe2\x80\x8fghi", 0),"[ltr] balance string with multiple U+200F chars but less U+200E chars" );
	is ("abcdef",input_clean("\xe2\x80\x8eabcdef",0),"[ltr] strip leading U+200E character from LTR string" );
	
	is( "\xe2\x80\xaeabcdef\xe2\x80\xad",input_clean("\xe2\x80\xaeabcdef", 0),"[ltr] balance string with U+202E char but no U+202D char" );
	is( "\xe2\x80\xaeabcdef\xe2\x80\xad",input_clean("\xe2\x80\xaeabcdef\xe2\x80\xad", 0),"[ltr] don't balance string with balanced U+202E/U+202D chars" );
	is( "abcdef\xe2\x80\xae\xe2\x80\xad",input_clean("\xe2\x80\xadabcdef\xe2\x80\xae", 0),"[ltr] balance string with balanced U+202D then U+202E chars" );
	is( "\xe2\x80\xaeabc\xe2\x80\xaedef\xe2\x80\xad",input_clean("\xe2\x80\xaeabc\xe2\x80\xaedef", 0),"[ltr] balance string with multiple U+202E chars but no U+202D char" );
	is( "abc\xe2\x80\xaddef",input_clean("\xe2\x80\xadabc\xe2\x80\xaddef", 0),"[ltr] don't balance string with multiple U+202D chars but no U+202E char" );
	is( "\xe2\x80\xaeabc\xe2\x80\xad:\xe2\x80\xaedef\xe2\x80\xad",input_clean("\xe2\x80\xaeabc\xe2\x80\xad:\xe2\x80\xaedef", 0),"[ltr] balance string with multiple U+202E chars but only one U+202D char" );
	is( "\xe2\x80\xaeabc\xe2\x80\xad:\xe2\x80\xaedef\xe2\x80\xad:\xe2\x80\xaeghi\xe2\x80\xad",input_clean("\xe2\x80\xaeabc\xe2\x80\xad:\xe2\x80\xaedef\xe2\x80\xad:\xe2\x80\xaeghi", 0),"[ltr] balance string with multiple U+202E chars but less U+202D chars" );
	is ("abc",input_clean("\xe2\x80\xadabc",0),"[ltr] strip leading U+202D character from LTR string" );
	
	is( "\xe2\x80\x8eabcdef\xe2\x80\x8f",input_clean("\xe2\x80\x8eabcdef", 0, 'rtl'),"[rtl] balance string with U+200E char but no U+200F char" );
	is( "\xe2\x80\x8eabcdef\xe2\x80\x8f",input_clean("\xe2\x80\x8eabcdef\xe2\x80\x8f", 0, 'rtl'),"[rtl] don't touch string with balanced U+200E/U+200F chars" );
	is( "abcdef\xe2\x80\x8e\xe2\x80\x8f",input_clean("\xe2\x80\x8fabcdef\xe2\x80\x8e", 0, 'rtl'),"[rtl] balance string with balanced U+200F then U+200E" );
	is( "\xe2\x80\x8eabc\xe2\x80\x8edef\xe2\x80\x8f",input_clean("\xe2\x80\x8eabc\xe2\x80\x8edef", 0, 'rtl'),"[rtl] balance string with multiple U+200E chars but no U+200F char" );
	is( "abc\xe2\x80\x8fdef",input_clean("\xe2\x80\x8fabc\xe2\x80\x8fdef", 0, 'rtl'),"[rtl] don't balance string with multiple U+200F chars but no U+200E char" );
	is( "\xe2\x80\x8eabc\xe2\x80\x8f:\xe2\x80\x8edef\xe2\x80\x8f",input_clean("\xe2\x80\x8eabc\xe2\x80\x8f:\xe2\x80\x8edef", 0, 'rtl'),"[rtl] balance string with multiple U+200E chars but only one U+200F char" );
	is( "\xe2\x80\x8eabc\xe2\x80\x8f:\xe2\x80\x8edef\xe2\x80\x8f:\xe2\x80\x8eghi\xe2\x80\x8f",input_clean("\xe2\x80\x8eabc\xe2\x80\x8f:\xe2\x80\x8edef\xe2\x80\x8f:\xe2\x80\x8eghi", 0, 'rtl'),"[rtl] balance string with multiple U+200E chars but less U+200F chars" );
	is ("abcdef",input_clean("\xe2\x80\x8fabcdef",0, 'rtl'),"[rtl] strip leading U+200F character from RTL string" );

	is( "\xe2\x80\xadabcdef\xe2\x80\xae",input_clean("\xe2\x80\xadabcdef", 0, 'rtl'),"[rtl] balance string with U+202D char but no U+202E char" );
	is( "\xe2\x80\xadabcdef\xe2\x80\xae",input_clean("\xe2\x80\xadabcdef\xe2\x80\xae", 0, 'rtl'),"[rtl] don't balance string with balanced U+202D/U+202E chars" );
	is( "abcdef\xe2\x80\xad\xe2\x80\xae",input_clean("\xe2\x80\xaeabcdef\xe2\x80\xad", 0, 'rtl'),"[rtl] balance string with balanced U+202E then U+202D chars" );
	is( "\xe2\x80\xadabc\xe2\x80\xaddef\xe2\x80\xae",input_clean("\xe2\x80\xadabc\xe2\x80\xaddef", 0, 'rtl'),"[rtl] balance string with multiple U+202D chars but no U+202E char" );
	is( "abc\xe2\x80\xaedef",input_clean("\xe2\x80\xaeabc\xe2\x80\xaedef", 0, 'rtl'),"[rtl] don't balance string with multiple U+202E chars but no U+202D char" );
	is( "\xe2\x80\xadabc\xe2\x80\xae:\xe2\x80\xaddef\xe2\x80\xae",input_clean("\xe2\x80\xadabc\xe2\x80\xae:\xe2\x80\xaddef", 0, 'rtl'),"[rtl] balance string with multiple U+202D chars but only one U+202E char" );
	is( "\xe2\x80\xadabc\xe2\x80\xae:\xe2\x80\xaddef\xe2\x80\xae:\xe2\x80\xadghi\xe2\x80\xae",input_clean("\xe2\x80\xadabc\xe2\x80\xae:\xe2\x80\xaddef\xe2\x80\xae:\xe2\x80\xadghi", 0, 'rtl'),"[rtl] balance string with multiple U+202D chars but less U+202E chars" );
	is ("abc",input_clean("\xe2\x80\xaeabc",0, 'rtl'),"[rtl] strip leading U+202E character from RTL string" );

	print("# \xe2\x80\x8e\xe2\x80\xad output should be fine from here\n");

?>
