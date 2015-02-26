#!/bin/bash
# syntax:  microsoft-translate.sh SOURCE TARGET PHRASE
# example: microsoft-translate.sh '' pt-BR 'Spaghetti alla puttanesca means spaghetti of the whore'
# Note: this doesn't currently check if the language arguments are valid, nor it handles errors like network failure.
# This script has been tested and works on MSYSGIT's "Bash for Windows", with support for unicode (like CJK characters).
h1="Content-Type: text/xml"; h2='SOAPAction: "http://api.microsofttranslator.com/V2/LanguageService/Translate"'
superBoring='<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns5="http://schemas.microsoft.com/2003/10/Serialization/Arrays" xmlns:ns6="http://schemas.datacontract.org/2004/07/Microsoft.MT.Web.Service.V2" xmlns:ns4="http://schemas.microsoft.com/2003/10/Serialization/" xmlns:ns1="http://tempuri.org/" xmlns:ns3="http://api.microsofttranslator.com/V2"><SOAP-ENV:Body><ns3:Translate><ns3:appId>BCF6F358A4128F7AFBDCE5E765EBC01B9DEF7586</ns3:appId><ns3:text>'
megaBoring='</ns3:text><ns3:from>'
ultraBoring='</ns3:from><ns3:to>'
hyperBoring='</ns3:to></ns3:Translate></SOAP-ENV:Body></SOAP-ENV:Envelope>'
source="$1"
destination="$2"
shift 2
xmlentities() { sed -r 's/\\/\\\\/g;s/&/\&amp;/g;s/"/\&quot;/g;s/'\''/\&apos;/g;s/</\&lt;/g;s/>/\&gt;/g' | iconv -f UTF-8 -t JAVA | sed -r 's/\\u([0-9a-f]{4})/\&#x\1;/g;s/\\&#x([0-9a-f]{4});/\\u\1/g'; }
text="$(xmlentities <<< "$@")"
request="$superBoring$text$megaBoring$source$ultraBoring$destination$hyperBoring"
pattern='s#.*<TranslateResult>##g;s#</TranslateResult>.*##g'
response="$(wget -qO- --header="$h1" --header="$h2" --user-agent="gSOAP/2.8" --post-data="$request" http://api.microsofttranslator.com/V2/soap.svc)"
if (($?)); then
    exit 1 # Error with wgetting.
else
    printf %s "$response" | sed -r "$pattern"
fi
