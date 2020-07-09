<!DOCTYPE html>
<html>
<head>
	<title>D&D Tool</title>
</head>
<body>
	<h1>Dungeons and Dragons Tool</h1>

	<a href="..">Back to main page</a>

	<h2>The Scenario</h2>
	You are a Dungeon Master for a D&D campaign.<br>
	You want your player to roll a die to determine the outcome of some scenario, and you want to choose precisely the expected value of the player's roll.<br>
	However, you have your principles: you don't want to go beyond the rules of D&D (except for the rule that says advantage and disadvantage don't stack).<br>
	Thankfully, using some sequence of advantage and disadvantage, you can create a distribution with any expected value you choose (provided that it's between 1 and the number of sides on the die being rolled).<br>
	The tool on this page does most of the hard work for you.<br>

	<h2>The Tool</h2>
	When reading the output of this tool, note that "with" is left associative.<br>
	For example, "roll a d20 with advantage with disadvantage with advantage" means that you'll take advantage on "roll a d20 with advantage with disadvantage," et cetera.<br>
	This means that if there are <var>n</var> tokens ("advantage" or "disadvantage") in the output, you'll have to roll <var>2<sup>n</sup></var> dice in total.<br> 

	<br>
	<form action="/dndtool/exec.php">
		Number of sides on the die:<br>
		<input type="text" name="n" value="20"><br>
		Desired expected value:<br>
		<input type="text" name="e" value="10.5"><br>
		Acceptable margin of error:<br>
		<input type="text" name="a" value="0.01"><br>
		<input type="hidden" name="run" value="true"><br>
		<input type="submit">
	</form>
	<br>

<?php
if ($_GET['run']) {
	$n = $_GET['n'];
	$e = $_GET['e'];
	$a = $_GET['a'];
	$output = shell_exec("/var/www/html/dndtool/timer.sh $n $e $a");
	echo "$output";
}
?>

	<h2>Source Code</h2>
	To use the following source code you'll need to have <code>ghc</code> installed.<br>
	To compile the program, type "<code>ghc -O Main.hs</code>".<br>
	To run it type "<code>./Main n e a</code>" where <var>n</var>, <var>e</var>, and <var>a</var> are the values you would type in the above input boxes.<br>
	
	<br>
	<a href="DnD.hs">DnD.hs</a>
	<br>
	<a href="Main.hs">Main.hs</a>

</html>
