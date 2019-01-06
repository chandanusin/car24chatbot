<?php
    
    // Create connection
    $con=mysqli_connect("db4free.net","caddac","caddac5jan","cars24x7");
    
    // Check connection
    if (mysqli_connect_errno())
    {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
    }
    
   
    $brand = $_GET['brand'];
    $model = $_GET['model'];
    $location = $_GET['location'];
    $ownership = $_GET['ownership'];
    $price = $_GET['price'];
    $kmsDriven = $_GET['kmsDriven'];
    $carType = $_GET['carType'];
    $engineType = $_GET['engineType'];
    $yearOfManufacture = $_GET['yearOfManufacture'];
    $addId = $_GET['addId'];
    $pincode = $_GET['pincode'];
    $image = $_GET['image'];
    $extra4 = $_GET['extra4'];
    $extra5 = $_GET['extra5'];
    $name = $_GET['ownerName'];
    
    if($brand==null && $model==null && $location == null && $ownership == null && $price == null && $kmsDriven == null && $carType == null && $engineType == null && $yearOfManufacture == null)
    {
        $sql = "SELECT * FROM usedCars";
        #echo $sql."1  ";
    } else {
        $sql = "INSERT INTO usedCars (brand, model, location, ownership, price, kmsDriven, carType, engineType, yearOfManufacture, addId, pincode, image, extra4, ownerName , extra5) VALUES ";
        #echo $sql."2  ";
      if ($brand!=null) {
          $sql = $sql."(" ."'". $brand."'".",";
          # echo $sql."3  ";
      }
      if ($model!=null) {
          $sql = $sql." '". $model."'".",";
          #echo $sql."4  ";
      }
      if ($location!=null) {
            $sql = $sql." '". $location."'".",";
          # echo $sql."4  ";
      }
      if ($ownership!=null) {
             $sql = $sql." '". $ownership."'".",";
          # echo $sql."4  ";
      }
      if ($price!=null) {
           $sql = $sql." '". $price."'".",";
          # echo $sql."4  ";
      }
      if ($kmsDriven!=null) {
           $sql = $sql." '". $kmsDriven."'".",";
          # echo $sql."4  ";
      }
      if ($carType!=null) {
           $sql = $sql." '". $carType."'".",";
          # echo $sql."4  ";
      }
      if ($engineType!=null) {
          $sql = $sql." '". $engineType."'".",";
          # echo $sql."4  ";
      }
      if ($yearOfManufacture!=null) {
           $sql = $sql." '". $yearOfManufacture."'".",";
          # echo $sql."4  ";
      }
      if ($addId!=null) {
             $sql = $sql." '". $addId."'".",";
          #  echo $sql."4  ";
      }
      if ($pincode!=null) {
           $sql = $sql." '". $pincode."'".",";
          # echo $sql."4  ";
      }
      if ($image!=null) {
            $sql = $sql." '". $image."'".",";
            # echo $sql."4  ";
      }
        if ($extra4!=null) {
            $sql = $sql." '". $extra4."'".",";
            # echo $sql."4  ";
        }
        if ($name!=null) {
            $sql = $sql." '". $name."'".",";
            # echo $sql."4  ";
        }
        if ($extra5!=null) {
            $sql = $sql." '". $extra5."'".")";
            # echo $sql."4  ";
        }
        # echo $sql."5  ";
    }
    echo $sql."6  ";
    
    #$queryString = "SELECT a.p_id, a.p_name, a.p_prize, b.p_id b.color, b.category, b.subcategory
    #FROM products a INNER JOIN details b ON a.p_id=b.p_id WHERE b.category = '" . mysql_real_escape_string( $cat ) . "' AND b.subcategory = '" . mysql_real_escape_string( $subcat ) . "' AND b.color = '" . mysql_real_escape_string( $color ) . "' ";
    // Check if there are results
    if ($result = mysqli_query($con, $sql))
    {
        // If so, then create a results array and a temporary one
        // to hold the data
        $resultArray = array();
        $tempArray = array();
        
        // Finally, encode the array to JSON and output the results
        echo json_encode($resultArray);
    }
    
    // Close connections
    mysqli_close($con);
    ?>
