<?php
$servername = "localhost";
$username   = "asaboleh_mybookshelfadmin";
$password   = "7nfIczHy!iyl";
$dbname     = "asaboleh_mybookshelf";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>