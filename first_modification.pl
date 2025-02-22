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
                              # The list starts with index 0

# Input string 2 from user
print "Input string 2 \n";
$line = <>;
chomp $line;
@string2 = split(//, $line);

$n = @string1;  # Assigning a list to a scalar just assigns the number of elements in the list to the scalar
$m = @string2;

print "The lengths of the two strings are $n, $m \n";  # Just to verify the lengths are correct

#initialize matrices to be used when finding max alignment option at the end 
$V[0][0] = 0;  # begin with 0,0 to initialize 
$matches[0][0] = 0;  # tracks number of matches
$mismatches[0][0] = 0;  # tracks number of mismatches
$indels[0][0] = 0;  # tracks number of indels

 # iterate through indices of sequence 1 and compare to 0th index of sequence 2
for ($i = 1; $i <= $n; $i++) {  # iterate through indices and compare to 0th index of sequence
   $V[$i][0] = $V[$i-1][0] - $Im;  # assigns a gap penalty for first column (indels)
   $matches[$i][0] = 0;
   $mismatches[$i][0] = 0;
   $indels[$i][0] = $indels[$i-1][0] + 1;  # increment indels
   print OUT "$string1[$i-1]";  # -1 because array indices start at [0]
}
print OUT "\n\n";

 # iterate through indices of sequence 2 and compare to 0th index of sequence 3
for ($j = 1; $j <= $m; $j++) {  
   $V[0][$j] = $V[0][$j-1] - $Im;  # updating alignment score for each index
   $matches[0][$j] = 0; 
   $mismatches[0][$j] = 0;
   $indels[0][$j] = $indels[0][$j-1] + 1;  # increment indels
   print OUT "$string2[$j-1]";  # output characters from sequence 2
}
print OUT "\n\n";

# fill in V matrix
for ($i = 1; $i <= $n; $i++) {
  for ($j = 1; $j <= $m; $j++) {

    # find diagonal alignment value
    if ($string1[$i-1] eq $string2[$j-1]) {  # if characters match
      $diagonal_score = $V[$i-1][$j-1] + $V_match;  
      $diagonal_match = $matches[$i-1][$j-1] + 1;  # case of a match
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
    $score_up = $V[$i-1][$j] - $Im;   # what is the score of the upper cell?
    $match_up = $matches[$i-1][$j];   
    $mismatch_up = $mismatches[$i-1][$j];
    $indel_up = $indels[$i-1][$j] + 1;

    # case of deletion (gap in seq 1)
    $score_left = $V[$i][$j-1] - $Im;  # what is the score of the cell to the left?
    $match_left = $matches[$i][$j-1];
    $mismatch_left = $mismatches[$i][$j-1];
    $indel_left = $indels[$i][$j-1] + 1;

    # choose the move that maximizes the overall highest score
    if ($diagonal_score >= $score_up && $diagonal_score >= $score_left) {  # case where value for this cell
      $V[$i][$j] = $diagonal_score;                                        # should taken from diagonal cell
      $matches[$i][$j] = $diagonal_match;
      $mismatches[$i][$j] = $diagonal_mismatch;
      $indels[$i][$j] = $diagonal_indel;
    } 
    
    elsif ($score_up >= $score_left) {  # case where value for this cell 
      $V[$i][$j] = $score_up;           # should taken from upper cell
      $matches[$i][$j] = $match_up;
      $mismatches[$i][$j] = $mismatch_up;
      $indels[$i][$j] = $indel_up;
    } 
    
    else {  # Left move is best    # case where value for this cell 
      $V[$i][$j] = $score_left;    # should taken from left cell
      $matches[$i][$j] = $match_left;
      $mismatches[$i][$j] = $mismatch_left;
      $indels[$i][$j] = $indel_left;
    }

    # get overall high score
    # print OUT "V[$i][$j] = $V[$i][$j] (Matches: $matches[$i][$j], Mismatches: $mismatches[$i][$j], Indels: $indels[$i][$j])\n";
  }
}

# calculate overall highest alignment score 
$final_matches = $matches[$n][$m];  # count number of matches
$final_mismatches = $mismatches[$n][$m];  # count number of mismatches
$final_indels = $indels[$n][$m];  # count number of indels
$final_score = ($V_match * $final_matches) - ($Cm * $final_mismatches) - ($Im * $final_indels);

# print the final similarity score and counts
print OUT "\nFinal alignment score: $V[$n][$m]\n"; 
print "\nFinal alignment score: $V[$n][$m]\n"; 
print "Overall best alignment score: $final_score\n";  #  maximized alignment score

close(OUT);  # Close output file
