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
    
    if($brand==null && $model==null && $location == null && $ownership == null && $price == null && $kmsDriven == null && $carType == null && $engineType == null && $yearOfManufacture == null)
    {
        $sql = "SELECT * FROM usedCars";
        #echo $sql."1  ";
    } else {
        $sql = "SELECT * FROM usedCars WHERE";
        #echo $sql."2  ";
      if ($brand!=null) {
          $sql = $sql." brand =" ."'". $brand."'"." AND";
          # echo $sql."3  ";
      }
      if ($model!=null) {
          $sql = $sql." model =" ."'". $model."'"." AND";
          #echo $sql."4  ";
      }
      if ($location!=null) {
            $sql = $sql." location =" ."'". $location."'"." AND";
          # echo $sql."4  ";
      }
      if ($ownership!=null) {
            $sql = $sql." ownership =" ."'". $ownership."'"." AND";
          # echo $sql."4  ";
      }
      if ($price!=null) {
            $sql = $sql." price =" ."'". $price."'"." AND";
          # echo $sql."4  ";
      }
      if ($kmsDriven!=null) {
            $sql = $sql." kmsDriven =" ."'". $kmsDriven."'"." AND";
          # echo $sql."4  ";
      }
      if ($carType!=null) {
            $sql = $sql." carType =" ."'". $carType."'"." AND";
          # echo $sql."4  ";
      }
      if ($engineType!=null) {
           $sql = $sql." engineType =" ."'". $engineType."'"." AND";
          # echo $sql."4  ";
      }
      if ($yearOfManufacture!=null) {
            $sql = $sql." yearOfManufacture =" ."'". $yearOfManufacture."'"." AND";
          # echo $sql."4  ";
      }
      if ($addId!=null) {
            $sql = $sql." addId =" ."'". $addId."'"." AND";
          #  echo $sql."4  ";
      }
      if ($pincode!=null) {
            $sql = $sql." pincode =" ."'". $pincode."'"." AND";
          # echo $sql."4  ";
      }
      $sql = substr($sql, 0, -4);
        # echo $sql."5  ";
    }
    #echo $sql."6  ";
    
    #$queryString = "SELECT a.p_id, a.p_name, a.p_prize, b.p_id b.color, b.category, b.subcategory
    #FROM products a INNER JOIN details b ON a.p_id=b.p_id WHERE b.category = '" . mysql_real_escape_string( $cat ) . "' AND b.subcategory = '" . mysql_real_escape_string( $subcat ) . "' AND b.color = '" . mysql_real_escape_string( $color ) . "' ";
    // Check if there are results
    if ($result = mysqli_query($con, $sql))
    {
        // If so, then create a results array and a temporary one
        // to hold the data
        $resultArray = array();
        $tempArray = array();
        
        // Loop through each row in the result set
        while($row = $result->fetch_object())
        {
            // Add each row into our results array
            $tempArray = $row;
            array_push($resultArray, $tempArray);
        }
        
        // Finally, encode the array to JSON and output the results
        echo json_encode($resultArray);
    }
    
    // Close connections
    mysqli_close($con);
    ?>
