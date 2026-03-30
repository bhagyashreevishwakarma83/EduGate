<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Upload Video</title>
        <link rel="stylesheet" href="css.css">
    </head>
    <body class="upload-body">
        <% 
          HttpSession hs = request.getSession(false);
          if (hs != null) {
              Integer fid = (Integer) hs.getAttribute("fid");
        %>
        <div class="upload-container">
            <h2 class="upload-heading">Upload Video</h2>
            <form action="Upload" method="post" enctype="multipart/form-data" class="upload-form">
                <label>Faculty ID</label>
                <input type="text" name="fid" value="<%= fid %>" readonly>

                <label>Topic Name</label>
                <input type="text" name="topic" placeholder="Enter the Topic">

                <label>Upload Video</label>
                <input type="file" name="vdio">

                <input type="submit" value="Upload" class="upload-btn">
            </form>
        </div>
        <% 
            } else {
                out.println("<h3 style='color:red; text-align:center;'>Session has expired. Please login again.</h3>"); 
            }
        %>
    </body>
</html>
