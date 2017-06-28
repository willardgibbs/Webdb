package Webdb;

use strict;
use warnings;

use Dancer2;
use DBI;

our $VERSION = '0.2';

our $driver = "mysql";
our $user_name = "";
our $password = "";

# Method get

get '/*/*/*' => sub {
	# Take id and names of bd and table

	my ($db_name, $table, $id) = splat;
	
	# Connect to bd
	
	my $dbh = DBI->connect("dbi:$driver:dbname=$db_name", $user_name, $password, {AutoCommit => 0, RaiseError => 1});
	
	# Check name of table on validity

	return {error => "Wrong name of table"} unless grep {$_ eq $table} @{$dbh->selectcol_arrayref('SHOW TABLES')};
	
	# Select by id
	
	my $sth = $dbh->prepare("SELECT * FROM $table WHERE id = ?");
	$sth->execute($id);
	
	# Return hash with id from select

	my $hash = $sth->fetchrow_hashref();
	return defined $hash ? $hash : {error => "Wrong id"};
};

# Method post

post '/*/*/' => sub {
	
	# Take names of bd and table

	my ($db_name, $table) = splat;

	#Conect to bd

	my $dbh = DBI->connect("dbi:$driver:dbname=$db_name", $user_name, $password, {AutoCommit => 0, RaiseError => 1});

	# Check name of table on validity

	return {error => "Wrong name of table"} unless grep {$_ eq $table} @{$dbh->selectcol_arrayref('SHOW TABLES')};

	# Take all params
	
	my %all_parameters = params;

	# But slat have already been used

	delete($all_parameters{"splat"});

	# We should control validity of fields

	my %columns = map {$_ => 1} @{$dbh->selectcol_arrayref("SHOW COLUMNS FROM $table")};

	# Let's form query

	my @fields = keys %all_parameters; # field's names of columns
	my @where_sel; 	# for forming string for select query
	my @vals; # values correspond to fields

	for (@fields) {

		# for validity of fields
		return {error => "Wrong column $_"} unless defined $columns{$_};

		# form post query
		push @vals, $all_parameters{$_};
		push @where_sel, $_ . " = ?";
	}

	# Insert-query

	my $sth = $dbh->do("INSERT INTO $table (" . join(",", @fields) . ") VALUES (" . join(",", ("?")x@fields) . ")", undef, @vals);
	$dbh->commit;
	
	# Let get id of inserted entry

	my $select = $dbh->prepare("SELECT id FROM $table WHERE " . join("and ", @where_sel)); 
	$select->execute(@vals);
	return {id => $select->fetchrow_hashref()->{id}};
};

# Method put

put '/*/*/*' => sub {

	# Take id and name of bd and table

	my ($db_name, $table, $id) = splat;

	# Connect to db

	my $dbh = DBI->connect("dbi:$driver:dbname=$db_name", $user_name, $password, {AutoCommit => 0, RaiseError => 1});

	# Check name of table on validity

	return {error => "Wrong name of table"} unless grep {$_ eq $table} @{$dbh->selectcol_arrayref('SHOW TABLES')};

	# Take all params
	
	my %all_parameters = params;

	# But slat have already been used

	delete($all_parameters{"splat"});

	# We should control validity of fields

	my %columns = map {$_ => 1} @{$dbh->selectcol_arrayref("SHOW COLUMNS FROM $table")};

	# Let's form query

	my @set; # for forming string for update query
	my @vals; #

	for (keys %all_parameters) {

		# for validity of fields
		return {error => "Wrong column $_"} unless defined $columns{$_};

		# form string for update query
		push @set, "$_ = ?";
		push @vals, $all_parameters{$_};
	}

	# Update

	my $result = $dbh->do("UPDATE $table SET " . join(", ", @set) . " WHERE id = ?", undef, @vals, $id) ? "success" : "failure";
	$dbh->commit;

	return {result => $result};
};

# Method delete

del "/*/*/*" => sub {
	
	# Take id and name of bd and table
	
	my ($db_name, $table, $id) = splat;
	
	# Connect to db
	
	my $dbh = DBI->connect("dbi:$driver:dbname=$db_name", $user_name, $password, {AutoCommit => 0, RaiseError => 1});

	# Check name of table on validity

	return {error => "Wrong name of table"} unless grep {$_ eq $table} @{$dbh->selectcol_arrayref('SHOW TABLES')};

	# Delete query

	my $result = $dbh->do("DELETE FROM $table WHERE id = ?", undef, $id) ? "success" : "failure";
	$dbh->commit();

	return {result => $result};
};

1;