<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error - ReLuvd</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        html, body {
            height: 100%;
            margin: 0;
        }

        .wrapper {
            min-height: 100%;
            display: flex;
            flex-direction: column;
        }

        .custom-header {
            background-color: #244C45;
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .custom-header .logo {
            height: 60px;
            margin-right: 1rem;
        }

        .brand-text h1 {
            margin: 0;
            font-size: 1.8rem;
        }

        .brand-text p {
            margin: 0;
            font-size: 0.9rem;
            color: #ccc;
        }

        .error-wrapper {
            max-width: 700px;
            margin: auto;
            padding: 3rem 1rem;
            text-align: center;
        }

        .error-icon {
            font-size: 4rem;
            color: #d9534f;
        }

        .btn-home {
            margin-top: 2rem;
            background-color: #244C45;
            color: white;
        }

        .btn-home:hover {
            background-color: #1a362f;
        }

        .custom-footer {
            background-color: #244C45;
            color: white;
            text-align: center;
            padding: 1rem;
            margin-top: auto;
        }
    </style>
</head>
<body>
<div class="wrapper">

    <header class="custom-header">
        <div style="display: flex; align-items: center;">
            <img src="${pageContext.request.contextPath}/images/reluvd-logo.png" alt="ReLuvd Logo" class="logo"/>
            <div class="brand-text">
                <h1>ReLuvd</h1>
                <p>Because OLD is the new NEW!</p>
            </div>
        </div>
    </header>

    <div class="container error-wrapper">
        <div class="error-icon"><i class="fas fa-exclamation-triangle"></i></div>
        <h2 class="my-3">Oops! Something went wrong.</h2>
        <p class="text-danger fs-5"><c:out value="${error}" /></p>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-home mt-4">Back to Home</a>
    </div>

    <footer class="custom-footer">
        &copy; 2025 ReLuvd. All rights reserved.
    </footer>
</div>
</body>
</html>
