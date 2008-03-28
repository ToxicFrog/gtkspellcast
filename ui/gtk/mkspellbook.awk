BEGIN { FS="'"; desc = ""; }

/^\.SH BUGS/ { exit; }

/^\.I '.*':/ {
	print ""
	print "spell '" spell "' '" gest "' [["
	print desc
	print "]]"

	FS = " ";
	spell = $2;
	desc = "";
	flag = 1;
	next;
}

/^\.B .*/ && (flag == 1) {
	FS = "'";
	gest = $2;
	next;
}

/^\.PP/ && (flag == 1) {
	desc = desc "$pp";
	next;
}

(flag == 1) {
#	print $0;
	desc = desc " " $0;
	next;
}
