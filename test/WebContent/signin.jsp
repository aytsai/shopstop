<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Sign in &middot; ShopStop</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">

<!-- Le styles -->
<link href="./css/bootstrap.css" rel="stylesheet">
<style type="text/css">
body {
	padding-top: 40px;
	padding-bottom: 40px;
	background-color: #f5f5f5;
}

.form-signin {
	max-width: 300px;
	padding: 19px 29px 29px;
	margin: 0 auto 20px;
	background-color: #fff;
	border: 1px solid #e5e5e5;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius: 5px;
	-webkit-box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
	-moz-box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
	box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
}

.form-signin .form-signin-heading,.form-signin .checkbox {
	margin-bottom: 10px;
}

.form-signin input[type="text"],.form-signin input[type="password"] {
	font-size: 16px;
	height: auto;
	margin-bottom: 15px;
	padding: 7px 9px;
}
</style>
<link href="./css/bootstrap-responsive.css" rel="stylesheet">

<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
      <script src="../assets/js/html5shiv.js"></script>
    <![endif]-->

</head>

<body>

	<div class="container">

		<form class="form-signin">
			<h2 class="form-signin-heading">Please sign in</h2>
			<%@ page import="java.sql.*"%>
			<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		Statement statement = null;
		ResultSet rs = null;

		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/cse135?user=test&password=test");
			statement = conn.createStatement();
		    rs = statement.executeQuery("select * from cse135.USERS");
		    String action = request.getParameter("action");
		
		    else {
		    	if (session.getAttribute("username") != null) {
			    	out.println ("You're already signed in, " + session.getAttribute("username") + ".");
			    }
			    // sign in
			    if (action != null && action.equals("signin")) {
	                conn.setAutoCommit(false);
	                conn.setAutoCommit(false);
	                PreparedStatement check = null;
	                // check for existing name
	                check = conn.prepareStatement("SELECT * FROM cse135.USERS WHERE nam='" +
	                		request.getParameter("nam") + "'");
	                check.execute();
	                ResultSet resultSet = check.getResultSet(); //result set for records
					boolean recordFound = resultSet.next();
	                if (recordFound == false) {
	                	// report error
	                }
	                else {
	                	session.setAttribute("username", request.getParameter("nam"));
	                }
			    }
		 %>
			<input type="text" class="input-block-level" name="nam"
				placeholder="Name"> <input type="hidden" name="action"
				value="signin" /> <label class="checkbox"> <input
				type="checkbox" value="remember-me"> Remember me
			</label>
			<button class="btn btn-large btn-primary" type="submit">Sign
				in</button>
			No account? <a href="/test/signup.jsp">Sign up here.</a>
			<%
	       		}
				rs.close();
				statement.close();
				conn.close();
		} catch (Exception e) {
			System.out.println (e);
			System.out.println ("also you suck?!?!");
		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
				}
				rs = null;
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
				}
				pstmt = null;
			}
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
				} // Ignore
				conn = null;
			}
		}
	%>
		</form>

	</div>
	<!-- /container -->

</body>
</html>