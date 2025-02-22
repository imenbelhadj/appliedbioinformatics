#!/pkg/bin/perl -w

open (OUT, '> outer');  # Open a file called 'outer' for outputting.

# Collect user input for the value of a match 
print "Enter match value: ";
$V_match = <>;  # <> means user input
chomp $V_match;

# Collect user input for the cost of a mismatch
print "Enter mismatch cost: ";
$Cm = <>;
chomp $Cm;

# Collect user input for indel cost
print "Enter indel cost: ";
$Im = <>;
chomp $Im;

# Input string 1 from user
print "Input string 1 \n";
$line = <>;
chomp $line;
@string1 = split(//, $line);  # Split the line into individual characters and place them in a list

# Input string 2 from user
print "Input string 2 \n";
$line = <>;
chomp $line;
@string2 = split(//, $line);

$n = @string1;  # Assigning a list to a scalar just assigns the number of elements in the list to the scalar
$m = @string2;

print "The lengths of the two strings are $n, $m \n";  # Just to verify the lengths are correct

$V[0][0] = 0;  # Assign the 0,0 entry of the V matrix

# Assign the column 0 values and print String 1
for ($i = 1; $i <= $n; $i++) {  
   $V[$i][0] = $V[$i-1][0] + $Im;  # Assign gap penalties for the first column (indels)
   print OUT "$string1[$i-1]";  # Note the -1 because array indexes start at 0
}
print OUT "\n\n";  

# Assign the row 0 values and print String 2
for ($j = 1; $j <= $m; $j++) {  
   $V[0][$j] = $V[0][$j-1] + $Im;  # Assign gap penalties for the first row (indels)
   print OUT "$string2[$j-1]";  # Output characters from the second string
}
print OUT "\n\n";

# Follow the recurrences to fill in the V matrix
for ($i = 1; $i <= $n; $i++) {  # fixed loop issue
  for ($j = 1; $j <= $m; $j++) {

    # Compare characters and assign match/mismatch scores
    if (defined($string1[$i-1]) && defined($string2[$j-1])) {  # Check if elements exist
      if ($string1[$i-1] eq $string2[$j-1]) {  # Characters match
        $t = $V_match;
      } 
      else {  # Characters mismatch
        $t = $Cm;
      }
    } 
    else {
      $t = $Cm;  # otherwise, $t = mismatch cost
    }

    # Compute the possible scores
    $max = $V[$i-1][$j-1] + $t;  # Diagonal move for a match or mismatch

    if ($max < $V[$i][$j-1] + $Im) {  # move left if insertion
      $max = $V[$i][$j-1] + $Im;
    }

    if ($V[$i-1][$j] + $Im > $max) {  # move up if deletion
      $max = $V[$i-1][$j] + $Im;
    }

    $V[$i][$j] = $max;  # Assign best score
    print OUT "V[$i][$j] has value $V[$i][$j]\n";  # moved this inside loop for accurate output
  }
} 

# Print the final similarity score
print "\nThe similarity value of the two strings is $V[$n][$m]\n";  # Final score output

print OUT "\nThe similarity value of the two strings is $V[$n][$m]\n";  # Final score output

close(OUT);  # Close the output file
