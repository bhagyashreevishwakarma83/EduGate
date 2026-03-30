<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Access Video</title>
    <link rel="stylesheet" href="css.css">
</head>
<body class="student-access-body">
    <div class="student-access-container">
        <h2 class="student-access-heading">Access Subject Materials</h2>
        <form action="view_subject_details.jsp" method="get" class="student-access-form">
            <input type="text" name="subject" placeholder="Enter the subject" class="student-access-input" required><br><br>
            <input type="submit" value="Submit" class="student-access-btn">
        </form>
    </div>
</body>
</html>
