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
		   		out.println ("Hello " + session.getAttribute("username"));
				if (session.getAttribute("role").equals("Owner")) {
					if (action != null && action.equals("insert")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement(
						"INSERT INTO PRODUCTS (name, sku, cat, price) VALUES (?, ?, ?, ?)");
						pstmt.setString(1, request.getParameter("nam"));
						pstmt.setString(2, request.getParameter("sku"));
						
						// find category id
						PreparedStatement check2 = conn.prepareStatement(
		                		"SELECT * FROM CATEGORY WHERE nam='" +
		                		request.getParameter("category") + "'");
	            		check2.execute();
	            		ResultSet resultSet2 = check2.getResultSet(); //result set for records
						resultSet2.next();
						pstmt.setInt(3, resultSet2.getInt("id"));
	            				
						pstmt.setInt(4, Integer.parseInt(request.getParameter("price")));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
		            }
					if (action != null && action.equals("update")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement(
								"UPDATE PRODUCTS SET name = ?, sku = ?, cat = ?, price = ? WHERE id = ?");
						pstmt.setString(1, request.getParameter("nam"));
						pstmt.setString(2, request.getParameter("sku"));

						// find category id
						PreparedStatement check3 = conn.prepareStatement(
		                		"SELECT * FROM CATEGORY WHERE nam='" +
		                		request.getParameter("category") + "'");
	            		check3.execute();
	            		ResultSet resultSet3 = check3.getResultSet(); //result set for records
						resultSet3.next();
						pstmt.setInt(3, resultSet3.getInt("id"));
						
						pstmt.setInt(4, Integer.parseInt(request.getParameter("price")));
						pstmt.setInt(5, Integer.parseInt(request.getParameter("id")));
						int rowCount = pstmt.executeUpdate();
						conn.commit();
						conn.setAutoCommit(true);
					}
		            if (action != null && action.equals("delete")) {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement("DELETE FROM PRODUCTS WHERE id = ?");
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
	                <th>SKU</th>
	                <th>Category</th>
	                <th>Price</th>
	            </tr>
	
	            <tr>
	                <form action="products.jsp" method="POST">
	                    <input type="hidden" name="action" value="insert"/>
	                    <th>&nbsp;</th>
	                    <th><input value="" name="nam" size="10"/></th>
	                    <th><input value="" name="sku" size="15"/></th>
	                    <th><input value="" name="category" size="15"/></th>
	                    <th><input value="" name="price" size="15"/></th>
	                    <th><input type="submit" value="Insert"/></th>
	                </form>
	            </tr>
			 <%
			// Iterate over the ResultSet
				while (rs.next()) {
		%>

		<tr>
			<form action="products.jsp" method="POST">
				<input type="hidden" name="action" value="update" />
				<input type="hidden" name="id" value="<%=rs.getInt("id")%>" />
				<td><%=rs.getInt("id")%></td>
				<td><input value="<%=rs.getString("name")%>" name="nam" size="15" /></td>
				<td><input value="<%=rs.getString("sku")%>" name="sku" size="15" /></td>
				<%	PreparedStatement check4 = conn.prepareStatement(
		        		"SELECT * FROM CATEGORY WHERE id='" +
		        		rs.getInt("cat") + "'");
					check4.execute();
					ResultSet resultSet4 = check4.getResultSet(); //result set for records
					resultSet4.next();
				%>
				<td><input value="<%=resultSet4.getString("nam")%>" name="category" size="15" /></td>
				<td><input value="<%=rs.getInt("price")%>" name="price" size="15" /></td>
				<%-- Button --%>
				<td><input type="submit" value="Update"></td>
			</form>
			<form action="products.jsp" method="POST">
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
			System.out.println ("also you suck?!?!?!?!?!?");
		}
	%>
</body>
</html>