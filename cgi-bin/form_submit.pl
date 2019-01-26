#!/usr/bin/perl -w
use strict; 
## disables certain Perl expressions that could behave 
##unexpectedly or are difficult to debug, turning them into errors.
use warnings;
## enables the use of additional/optional warnings 
use DBI;
##The DBI is a database access module for the Perl programming language. 
##It defines a set of methods, variables, and conventions that provide a 
##consistent database interface, independent of the actual database being used.
use CGI qw(:standard);
##CGI is a Common Gateway Interface module that allows to process and prepare
##HTTP requests and responses. qw(:standard) indicates that the standard set of
##functions is being imported
use CGI::Carp qw(fatalsToBrowser);
##CGI::Carp is a module for giving better error messages

print "Content-type: text/html\n\n";
##gets sent back as part of the HTTP header to specify the type of content


##read form data
my $firstname = param('fname');
my $lastname = param('lname');
my $email = param('email');
my $phone_num = param('phone');

##param function/routine gives the value of the form field
##whose name is passed as a parameter

## a new variable is declared as my $variablename;
## later that variable may by called by just using $variablename (without the "my")

##Define SQL Vars
my $driver = "mysql"; 
my $database = "eshumeyk_web_main";
my $dsn = "DBI:$driver:$database:localhost";
my $userid = "eshumeyk_web";
my $password = "eshumeyk_web";

##Build Connection String and connect
my $dbh = DBI->connect($dsn, $userid, $password ) or die $DBI::errstr;

##Execute SQL
my $sth = $dbh->prepare("INSERT INTO contact_info_new
                       (first_name, last_name, email, phone )
                        values
                       (?,?,?,?)");
$sth->execute($firstname,$lastname,$email,$phone_num) 
          or die $DBI::errstr;
$sth->finish();
$dbh->disconnect();

##Connect to DB and extract # of entries
my $dbh = DBI->connect($dsn, $userid, $password ) or die $DBI::errstr;
my $sth = $dbh->prepare("SELECT COUNT(*) FROM contact_info_new");
$sth->execute() or die $DBI::errstr;
my $user_count=$sth->fetchrow_array();

$sth->finish();
$dbh->disconnect();

##Display
print "Thank you, ",$firstname,", for the form submission. Your submission # is ";#$user_count"!";
print $user_count;