#!/pkg/bin/perl -w

open (OUT, '> outer');  # Open a file called 'outer' for outputting.

# Set V_match valus, Cm, and Im values
$V_match = 1;  # <> means user input
#chomp $Im;

$Cm = 0;
#chomp $Cm;

$Im = 0;
#chomp $Im;

# input string 1 from user
print "Input string 1 \n";
$line = <>;
chomp $line;
$line =~ s/\s+//g;  # removes spaces
@string1 = split(//, $line);  # split the line into individual characters and place them in a list
                              # the list starts with index 0

# input string 2 from user
print "Input string 2 \n";
$line = <>;
chomp $line;
$line =~ s/\s+//g;  # removes spaces
@string2 = split(//, $line);

$n = @string1;  # Assigning a list to a scalar just assigns the number of elements in the list to the scalar
$m = @string2;

print "The lengths of the two strings are $n, $m \n";  # Just to verify the lengths are correct

# Initialize matrices to be used when finding max alignment option at the end
$V[0][0] = 0;  # Begin with 0,0 to initialize 
$matches[0][0] = 0;  # Tracks number of matches
$mismatches[0][0] = 0;  # Tracks number of mismatches
$indels[0][0] = 0;  # Tracks number of indels (gaps)

# Iterate through indices of sequence 1 and compare to 0th index of sequence 2
for ($i = 1; $i <= $n; $i++) {
   $V[$i][0] = $V[$i-1][0] - $Im;  # assigns a gap penalty for 1st column (indels)
   $matches[$i][0] = 0;
   $mismatches[$i][0] = 0;
   $indels[$i][0] = $indels[$i-1][0] + 1;  # increment indels
   print OUT "$string1[$i-1]";  # -1 because array indices start at [0]
}
print OUT "\n\n";

# Iterate through indices of sequence 2 and compare to 0th index of sequence 1
for ($j = 1; $j <= $m; $j++) {
   $V[0][$j] = $V[0][$j-1] - $Im;  # assigns gap penalty for 1st row (indels)
   $matches[0][$j] = 0;
   $mismatches[0][$j] = 0;
   $indels[0][$j] = $indels[0][$j-1] + 1;  # increment indels
   print OUT "$string2[$j-1]";  # Output characters from sequence 2
}
print OUT "\n\n";

# fill in the V matrix
for ($i = 1; $i <= $n; $i++) {
  for ($j = 1; $j <= $m; $j++) {

    # find diagonal alignment value
    if ($string1[$i-1] eq $string2[$j-1]) {  # case of a match
      $diagonal_score = $V[$i-1][$j-1] + $V_match;  
      $diagonal_match = $matches[$i-1][$j-1] + 1;
      $diagonal_mismatch = $mismatches[$i-1][$j-1];
      $diagonal_indel = $indels[$i-1][$j-1];
    } 
    else {  # case of a mismatch
      $diagonal_score = $V[$i-1][$j-1] - $Cm;  
      $diagonal_match = $matches[$i-1][$j-1];
      $diagonal_mismatch = $mismatches[$i-1][$j-1] + 1;
      $diagonal_indel = $indels[$i-1][$j-1];
    }

#Indels are deletions or insertions, so we have to account for both:
    # case of insertion (gap in seq 2)
    $score_up = $V[$i-1][$j] - $Im;  # gap penalty for insertion
    $match_up = $matches[$i-1][$j];
    $mismatch_up = $mismatches[$i-1][$j];
    $indel_up = $indels[$i-1][$j] + 1;  # increment indels for insertion

    # Case of deletion (gap in seq 1)
    $score_left = $V[$i][$j-1] - $Im;  # gap penalty for deletion
    $match_left = $matches[$i][$j-1];
    $mismatch_left = $mismatches[$i][$j-1];
    $indel_left = $indels[$i][$j-1] + 1;  # increment indels for deletion

    # Choose the move that maximizes the overall highest score
    if ($diagonal_score >= $score_up && $diagonal_score >= $score_left) {  # Case where value for this cell should come from diagonal
      $V[$i][$j] = $diagonal_score;
      $matches[$i][$j] = $diagonal_match;
      $mismatches[$i][$j] = $diagonal_mismatch;
      $indels[$i][$j] = $diagonal_indel;
    } 
    elsif ($score_up >= $score_left) {  # Case where value for this cell should come from above
      $V[$i][$j] = $score_up;
      $matches[$i][$j] = $match_up;
      $mismatches[$i][$j] = $mismatch_up;
      $indels[$i][$j] = $indel_up;
    } 
    else {  # Case where value for this cell should come from the left
      $V[$i][$j] = $score_left;
      $matches[$i][$j] = $match_left;
      $mismatches[$i][$j] = $mismatch_left;
      $indels[$i][$j] = $indel_left;
    }

    # Print the score matrix values with counts
    print OUT "V[$i][$j] has a score of $V[$i][$j]\n"; 
  }
}

# calculate overall highest alignment score 
$final_matches = $matches[$n][$m];  # count number of matches
$final_mismatches = $mismatches[$n][$m];  # count number of mismatches
$final_indels = $indels[$n][$m];  # count number of indels (gaps)

# Maximize objective function
$final_score = ($V_match * $final_matches) - ($Cm * $final_mismatches) - ($Im * $final_indels);

# Print the final similarity score and counts

#print OUT "\nFinal alignment score: $V[$n][$m]\n"; 
print OUT "\nThe length of the LCS is $final_score\n";  #  prints optimal alignment score (LCS)

#print "\nFinal alignment score: $V[$n][$m]\n";
print "The length of the LCS is $final_score\n";  #  prints optimal alignment score (LCS)

close(OUT);  # Close output file
