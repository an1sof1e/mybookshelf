<?php
error_reporting(0);
include_once("dbconnect.php");
$prid = $_POST['prid'];
$prname = $_POST['prname'];
$quantity = $_POST['quantity'];
$price = $_POST['price'];
$weight = $_POST['weight'];
$type = $_POST['type'];


$sqlupdate = "UPDATE PRODUCT SET NAME = '$prname', QUANTITY = '$quantity', PRICE = '$price', WEIGHT = '$weight', TYPE = '$type' WHERE ID = '$prid'";

 if ($conn->query($sqlupdate)){
        echo 'success';    
    }else{
        echo 'failed';
    }


$conn->close();
?>
