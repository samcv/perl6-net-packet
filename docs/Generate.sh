#!/bin/bash
set -e

perl6 -MPod::To::Markdown -e exit
rm *.md

for PERLMOD in Net/Packet \
	       Net/Packet/{Ethernet,MAC_addr,EtherType} \
	       Net/Packet/{IPv4,IPv4_addr,IP_proto} \
	       Net/Packet/{UDP,ARP,ICMP}; do
    DOCNAME=${PERLMOD//\//-}
    echo "$PERLMOD.pm6 -> $DOCNAME.md"
    echo -en "<!-- DO NOT EDIT: File generated by docs/Generate.sh -->\n\n" > "$DOCNAME.md"
    perl6 -I../lib --doc=Markdown "../lib/$PERLMOD.pm6" >> "$DOCNAME.md"
done

echo > ALL
for DOC in $(find . -name "*.md"); do
    echo -en '\n\n* * *\n\n' >> ALL
    cat $DOC >> ALL
done
mv ALL ALL.md
