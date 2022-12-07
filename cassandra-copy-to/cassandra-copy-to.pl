#!/bin/env perl

use strict;
use warnings;

my $FROM_SERVER='10.33.245.222'; # change here
my $TO_SERVER='177.153.231.114'; # change here
my $CSV_PATH='/storage/tmp'; # change here

my $KEYSPACE='btg360'; # change here
my $CQLCMD='cqlsh-astra/bin/cqlsh --connect-timeout=15'; # change here

my $GREP_TABLES_CMD="grep '_11255'"; # change here

my $help = 1;
my $time = time();

while (<>) {
    $_ =~ s/^\s+|\s+$//g;
    my $table_name = $_;
    last if $table_name eq '';
    $help = 0;

    my $filename = "$CSV_PATH/$table_name-$time.csv";
    my $filename_schema = "$CSV_PATH/schema-$table_name.cql";
    my $describe = "describe $KEYSPACE.$table_name;";
    my $copy_from_cmd = "COPY $KEYSPACE.$table_name TO   '$filename';";
    my $copy_to_cmd = "COPY $KEYSPACE.$table_name FROM '$filename';";
    print "\n#table $table_name from $FROM_SERVER to $TO_SERVER\n";
    print "set -x\n";
    print "$CQLCMD $FROM_SERVER -e \"$describe\" > $filename_schema\n";
    print "$CQLCMD $TO_SERVER < $filename_schema && rm -f $filename_schema\n";
    print "$CQLCMD $FROM_SERVER -e \"$copy_from_cmd\" > /dev/null\n";
    print "du -sh '$filename' '$filename_schema'\n";
    print "$CQLCMD $TO_SERVER -e \"$copy_to_cmd\" > /dev/null && rm -f $filename\n";
    print "du -sh '$CSV_PATH/*.csv' $CSV_PATH/*.cql\n";
}


if ($help) {
    print "# list tables\n";
    print "$CQLCMD $FROM_SERVER -e \"paging off; SELECT table_name FROM system_schema.tables WHERE  keyspace_name = '$KEYSPACE';\" | $GREP_TABLES_CMD | perl $0\n";
}

# du -h /storage/tmp/*.csv || cat nohup.out