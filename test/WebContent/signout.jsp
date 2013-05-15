<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Signed out</title>

<script LANGUAGE="JavaScript">
	var t = setTimeout(function() {
		window.location = "/test/"
	}, 2000);
</script>

</head>
<body>
	<h1>You've been signed out.</h1>
	<%
session.setAttribute("username", null);
%>
	<br />
	<br />

	<p>
		Click <a href="/test/">here</a> to return to the main page, or simply
		wait a couple seconds to be redirected.
	</p>
</body>
</html>