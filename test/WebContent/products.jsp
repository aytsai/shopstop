<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Ugliest Page</title>
</head>
<body>
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
		    rs = statement.executeQuery("select * from cse135.PRODUCTS");
		    String action = request.getParameter("action");
		
		   	if (session.getAttribute("username") != null) {
		   		// check if the user is an owner
		   		PreparedStatement check = null;
	            check = conn.prepareStatement("SELECT * FROM cse135.USERS WHERE nam='" +
	            		session.getAttribute("username") + "'");
	            check.execute();
	            ResultSet resultSet = check.getResultSet(); //result set for records
				resultSet.next();
				if ((resultSet.getString("role")).equals("Owner")) {
			%>
				<table border="1">
	            <tr>
	                <th>ID</th>
	                <th>Name</th>
	                <th>SKU</th>
	                <th>Category</th>
	                <th>Price</th>
	            </tr>
	
	            <tr>
	                <form action="product.jsp" method="POST">
	                    <input type="hidden" name="action" value="insert"/>
	                    <th>&nbsp;</th>
	                    <th><input value="" name="pid" size="10"/></th>
	                    <th><input value="" name="first" size="15"/></th>
	                    <th><input value="" name="middle" size="15"/></th>
	                    <th><input value="" name="last" size="15"/></th>
	                    <th><input type="submit" value="Insert"/></th>
	                </form>
	            </tr>
	            </table>
			<%
				}
				else {
					out.println ("Sorry, you aren't an owner, so you can't access this page.");
				}
		   	}
		   	else {
		   		out.println ("Please log in.");
		   	}
			rs.close();
			statement.close();
			conn.close();
		} catch (Exception e) {
			System.out.println (e);
			System.out.println ("also you suck?!?!");
		}
	%>
</body>
</html>