#!perl

use XML::SAX;

XML::SAX->remove_parser(q(XML::SAX::PurePerl))->save_parsers();
