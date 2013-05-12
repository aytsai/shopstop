<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Sign up &middot; ShopStop</title>
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


		<%-- Import the java.sql package --%>
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
		    
		    // insertion
            if (action != null && action.equals("insert")) {
                conn.setAutoCommit(false);
                pstmt = conn.prepareStatement("INSERT INTO USERS (nam, role, age, sta) VALUES (?, ?, ?, ?)");
                pstmt.setString(1, request.getParameter("nam"));
                pstmt.setString(2, request.getParameter("role"));
                pstmt.setInt(3, Integer.parseInt(request.getParameter("age")));
                pstmt.setString(4, request.getParameter("sta"));
                int rowCount = pstmt.executeUpdate();
                conn.commit();
                conn.setAutoCommit(true);
            }
            /*if (action != null && action.equals("delete")) {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement("DELETE FROM USERS WHERE id = ?");
				pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
				int rowCount = pstmt.executeUpdate();
				conn.commit();
				conn.setAutoCommit(true);
			}*/
		 %>
			<form class="form-signin" action="signup.jsp" method="POST">
				<h2 class="form-signin-heading">New Account</h2>
				<input type="text" class="input-block-level" name="nam" placeholder="Name">
				<select name="role">
					<option value="Owner">Owner</option>
					<option value="Customer">Customer</option>
				</select>
				<input type="text" class="input-block-level" name="age" placeholder="Age">
				<select name="sta">
							<option>Milk</option>
							<option>Coffee</option>
							<option>Tea</option>
					</select>
				<button class="btn btn-large btn-primary" type="submit">Sign up</button>
				Already have an account? <a href="/test/signin.jsp">Sign in
					here.</a>
			</form>

			<%-- -------- Iteration Code -------- --%>
			<%
			// Iterate over the ResultSet
				while (rs.next()) {
		%>

			<tr>
				<form action="signup.jsp" method="POST">
					<input type="hidden" name="action" value="update" /> <input
						type="hidden" name="id" value="<%=rs.getInt("id")%>" />

					<%-- Get the id --%>
					<td><%=rs.getInt("id")%></td>

					<%-- Get the pid --%>
					<td><input value="<%=rs.getString("nam")%>" name="nam"
						size="15" /></td>

					<%-- Get the first name --%>
					<td><input value="<%=rs.getString("role")%>" name="role"
						size="15" /></td>

					<%-- Get the middle name --%>
					<td><input value="<%=rs.getInt("age")%>" name="age" size="15" /></td>

					<%-- Get the last name --%>
					<td><input value="<%=rs.getString("sta")%>" name="sta"
						size="15" /></td>

					<%-- Button --%>
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="signup.jsp" method="POST">
					<input type="hidden" name="action" value="delete" /> <input
						type="hidden" value="<%=rs.getInt("id")%>" name="id" />
					<%-- Button --%>
					<td><input type="submit" value="Delete" /></td>
				</form>
			</tr>

			<%
			}
		%>

			<%-- This is a JSP Comment before JSP Scriplet --%>
			<%-- -------- Close Connection Code -------- --%>
			<%
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
		
	</div>
	<!-- /container -->

</body>
</html>