<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

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
	<table border="1">
		<tr>
			<th>ID</th>
			<th>Name</th>
			<th>Role</th>
			<th>Age</th>
			<th>State</th>
		</tr>

		<tr>
			<form action="index.jsp" method="POST">
				<input type="hidden" name="action" value="insert" />
				<th>&nbsp;</th>
				<th><input value="" name="nam" size="10" /></th>
				<th><select name="role">
						<option>Owner</option>
						<option>Customer</option>
				</select></th>
				<th><input value="" name="age" size="15" /></th>
				<th><select name="sta">
						<option>Milk</option>
						<option>Coffee</option>
						<option>Tea</option>
				</select></th>
				<th><input type="submit" value="Insert" /></th>
			</form>
		</tr>

		<%-- -------- Iteration Code -------- --%>
		<%
			// Iterate over the ResultSet
				while (rs.next()) {
		%>

		<tr>
			<form action="students.jsp" method="POST">
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
			<form action="index.jsp" method="POST">
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
	
</body>
</html>