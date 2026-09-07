<?php
session_start();
if (empty($_SESSION['auth'])) {
    header('Location: /login.php', true, 302);
    exit;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>OK</title>
</head>
<body>
  <p>Login successful (lab session).</p>
</body>
</html>
