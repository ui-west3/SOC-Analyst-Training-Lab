<?php
session_start();
$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user = isset($_POST['username']) ? (string) $_POST['username'] : '';
    $pass = isset($_POST['password']) ? (string) $_POST['password'] : '';
    if ($user === 'labuser' && $pass === 'labpass') {
        $_SESSION['auth'] = 1;
        header('Location: /success.php', true, 302);
        exit;
    }
    $error = 'Invalid username or password';
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Lab login</title>
  <style>
    body { font-family: system-ui, sans-serif; max-width: 24rem; margin: 3rem auto; }
    label { display: block; margin-top: 1rem; }
    input { width: 100%; padding: 0.4rem; box-sizing: border-box; }
    button { margin-top: 1rem; padding: 0.5rem 1rem; }
    .err { color: #b00020; margin-top: 1rem; }
  </style>
</head>
<body>
  <h1>Training login</h1>
  <form method="post" action="/login.php" autocomplete="off">
    <label for="username">Username</label>
    <input id="username" name="username" type="text" required>
    <label for="password">Password</label>
    <input id="password" name="password" type="password" required>
    <button type="submit">Sign in</button>
  </form>
  <?php if ($error !== '') { ?>
    <p class="err"><?php echo htmlspecialchars($error, ENT_QUOTES, 'UTF-8'); ?></p>
  <?php } ?>
</body>
</html>
