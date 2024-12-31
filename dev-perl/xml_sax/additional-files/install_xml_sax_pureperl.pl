#!perl

use XML::SAX;

XML::SAX->add_parser(q(XML::SAX::PurePerl))->save_parsers();
