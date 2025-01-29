<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cat Time</title>
    <style>
        body {
            font-family: "Times New Roman", Times, serif;
            max-width: 900px;
            margin: 0 auto;
            padding: 10px 15px;
        }

        #greeting {
            font-size: xx-large;
            position: relative;
            height: fit-content;
            overflow: hidden;
            aspect-ratio: 16 / 9;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            text-shadow: 1px 1px 2px black;
            font-weight: bold;
        }

        #greeting img {
            position: absolute;
            z-index: -1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        #hit-counter {
            position: fixed;
            font-size: xx-large;
            right: 5px;
            bottom: 5px;
        }

        #halloween-image {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 100px;
            opacity: 0.8;
        }
    </style>
</head>

<body>
    <?php
    $greeting = "";
    $backgroundImage = "";

    if (date("H") < 12) {
        $greeting = "Good Morning";
        $backgroundImage = "morning.jpg";
    } elseif (date("H") < 19) {
        $greeting = "Good Afternoon";
        $backgroundImage = "afternoon.jpg";
    } elseif (date("H") < 21) {
        $greeting = "Good Evening";
        $backgroundImage = "evening.jpg";
    } else {
        $greeting = "Good Night";
        $backgroundImage = "night.jpg";
    }
    ?>

    <div id="greeting">
        <img src="<?php echo $backgroundImage; ?>" alt="Background Image">
        <?php echo $greeting; ?>
    </div>

    <div id="hit-counter">
        <?php echo "Hits: " . file_get_contents("hit-counter.txt"); ?>
    </div>

    <?php
    $file = 'hit-counter.txt';
    if (file_exists($file)) {
        $hits = file_get_contents($file);
        $hits = (int)$hits + 1;
        file_put_contents($file, $hits);
    } else {
        file_put_contents($file, 1);
    }
    ?>
</body>
</html>
