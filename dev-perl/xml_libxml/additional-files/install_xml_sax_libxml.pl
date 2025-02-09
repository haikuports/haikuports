#!perl

use XML::SAX;

XML::SAX->add_parser(q(XML::LibXML::SAX::Parser));
XML::SAX->add_parser(q(XML::LibXML::SAX));
XML::SAX->save_parsers();
