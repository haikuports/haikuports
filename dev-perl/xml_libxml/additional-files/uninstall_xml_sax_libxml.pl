#!perl

use XML::SAX;

XML::SAX->remove_parser(q(XML::LibXML::SAX::Parser));
XML::SAX->remove_parser(q(XML::LibXML::SAX));
XML::SAX->save_parsers();
