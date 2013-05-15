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
		    rs = statement.executeQuery("select * from cse135.CATEGORY");
		    String action = request.getParameter("action");
		
		   	if (session.getAttribute("username") != null) {
		   		out.println ("Hello " + session.getAttribute("username"));
				if (session.getAttribute("role").equals("Owner")) {
					if (action != null && action.equals("insert")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement(
						"INSERT INTO CATEGORY (nam, description, own) VALUES (?, ?, ?)");
						pstmt.setString(1, request.getParameter("nam"));
						pstmt.setString(2, request.getParameter("description"));
						pstmt.setInt(3, (Integer) session.getAttribute("userid"));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
		            }
					if (action != null && action.equals("update")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement(
								"UPDATE CATEGORY SET nam = ?, description = ? WHERE id = ?");
						pstmt.setString(1, request.getParameter("nam"));
						pstmt.setString(2, request.getParameter("description"));
						pstmt.setInt(3, Integer.parseInt(request.getParameter("id")));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
					}
		            if (action != null && action.equals("delete")) {
		            	// does NOT have the product check yet
		            	// if there's a product referring to this category, there is no delete button
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement("DELETE FROM CATEGORY WHERE id = ?");
						pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
					}
					%>
						<table border="1">
			            <tr>
			                <th>ID</th>
			                <th>Name</th>
			                <th>Description</th>
			            </tr>
		
			            <tr>
			                	<form action="category.jsp" method="POST">
									<input type="hidden" name="action" value="insert"/>
									<th>&nbsp;</th>
									<th><input value="" name="nam" size="15"/></th>
									<th><input value="" name="description" size="15"/></th>
									<th><input type="submit" value="Insert"/></th>
								</form>
			            </tr>
			      <%
			// Iterate over the ResultSet
				while (rs.next()) {
		%>

		<tr>
			<form action="category.jsp" method="POST">
				<input type="hidden" name="action" value="update" />
				<input type="hidden" name="id" value="<%=rs.getInt("id")%>" />
				<td><%=rs.getInt("id")%></td>
				<td><input value="<%=rs.getString("nam")%>" name="nam" size="15" /></td>
				<td><input value="<%=rs.getString("description")%>" name="description" size="15" /></td>
				<%-- Button --%>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action="category.jsp" method="POST">
				<input type="hidden" name="action" value="delete" /> <input
					type="hidden" value="<%=rs.getInt("id")%>" name="id" />
				<%-- Button --%>
				<td><input type="submit" value="Delete" /></td>
			</form>
		</tr>
		<%
			}
		%>
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