<!DOCTYPE html>
<html>
<head>
    <title>Upload PDF</title>
    <link rel="stylesheet" href="css.css">
</head>
<body class="pdf-upload-body">
    <h2 class="pdf-upload-heading">Upload PDF</h2>

    <form method="post" action="upload_pdf" enctype="multipart/form-data" class="pdf-upload-form">
        <label class="pdf-upload-label">Topic:</label>
        <input type="text" name="topic" class="pdf-upload-input"><br><br>

        <label class="pdf-upload-label">Upload PDF:</label>
        <input type="file" name="pdf" class="pdf-upload-input"><br><br>

        <input type="submit" value="Upload PDF" class="pdf-upload-button">
    </form>
</body>
</html>
