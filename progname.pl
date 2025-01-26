# !/usr/bin/perl
#
# A Simple Printing Program 

print "1.1\n";
print "Welcome to Perl\n";    #Print a greeting, removing \n will make these two one line
print "TATA is a box\n";   #Print a second line



# Print example
#print 'hello\n';
#print "Hello\n";
#print "Hello\\\n"; "World\n"; print "b\ty\te\n";


print "1.2\n";
print "When in double quotes:\n";
print "Use \\\\ to output \\\n";
print "Use \\t to output tabs\n";

print "1.3\n";
$dnastring = 'actttgact';
$seconddna = 'tataccta';
print "$dnastring\n";
print "$dnastring \t $seconddna\n";

print "1.4\n";
$nucstring = 'acCtagGgCCTTAcga';
print "$nucstring \n";
$nucstring =~ tr/tT/uU/;
print "$nucstring \n";

print "1.5\n";
$sequence = 'VRNrIAEelslrrFMVALILdIKrTPgNKPriaemICDIDtYIvEa';
print "$sequence \n";
# $sequence =~ tr/A-Z/a-z/;
$sequence =~ tr/a-zA-Z/A-Za-z/;
print "$sequence \n"; 

print "1.6\n";
my %residuetypes = (
    'A' => 'A', 'C' => 'A', 'G' => 'A', 'P' => 'A', 'S' => 'A', 'T' => 'A', 'W' => 'A', 'Y' => 'A',
    'E' => 'E', 'N' => 'E', 'D' => 'E', 'Q' => 'E', 'H' => 'E', 'K' => 'E','R' => 'E',
    'I' => 'I', 'L' => 'I', 'M' => 'I', 'F' => 'I', 'V' => 'I'
);
# hash table that allows us to replace a char with the designated A/E/I we need, the blueprint essentially

my $sequence = "SEETQMRLQLKRKLQRNRTSFTQEQIEALEKEFERTHYPDVFARERL";

print "$sequence\n";

for (my $i = 0; $i < length($sequence); $i++) {   # iterate through each char in len of protein string
    my $char = substr($sequence, $i, 1); # Extract the character at position $i 
    my $translated_sequence = $residuetypes{$char} // die "letter is not accounted for"; # replace with appropriate character from hash table or break
    print "$translated_sequence";
}
print "\n";


print "1.7\n";
print "It may be a better idea to use c to find the location of any given improper characters, print that, then use c and d together to remove all improper amino acid characters.\n";


print "1.8 part 1\n";

print "input a sequence: \n";

$input = <STDIN>;  #collects user input of protein sequence

chomp ($input);   # removes \n to be able to translate

$input =~ tr/atcgATCG/tagcTAGC/;    

print "$input\n";    # print translation



print "1.8 part 2\n";

print "input a sequence: \n";

$dna = <STDIN>;  #collects user input of protein sequence

chomp ($dna);   # removes \n to be able to translate

$dna =~ tr/Tt/Uu/;   # replaces T with U in RNA 

print "$dna \n";    # print translation



print "1.9\n";
# Count all purines (Adenine and Guanine)

print "input a sequence: \n";

$dna = <STDIN>;  #collects user input of protein sequence

chomp $dna; # removes \n to be able to translate

my $purines = $dna;    # copy the original DNA sequence to be able to make changes and not lose original

$purines =~ tr/AGag//cd;  # remove non-purines (C and T) from sequence

my $count = length($purines);  # count the remaining characters

print "purines present in sequence: $count\n";

 







