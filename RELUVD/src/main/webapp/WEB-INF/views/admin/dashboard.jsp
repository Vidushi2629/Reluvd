<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | ReLuvd</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .dashboard-wrapper {
            max-width: 1100px;
            margin: 3rem auto;
            background-color: #fff;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .summary-card {
            min-height: 170px;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        .summary-btn {
            margin-top: auto;
        }

        .chart-container {
            height: 320px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .chart-container canvas {
            max-height: 100% !important;
            max-width: 100% !important;
            object-fit: contain;
        }
    </style>
</head>

<body>

<!-- Sidebar -->
<jsp:include page="/load-sidebar" />

<!-- Main Content -->
<div class="main-content">
    <%@ include file="/WEB-INF/views/includes/header.jsp" %>

    <div class="dashboard-wrapper">
        <h2 class="text-center mb-4">Admin Dashboard</h2>

        <!-- Summary Cards -->
        <div class="row text-white mb-4">
            <div class="col-md-3">
                <div class="card bg-primary text-center summary-card">
                    <div class="card-body">
                        <h5>Total Users</h5>
                        <p class="fs-4">${totalUsers}</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-center summary-card">
                    <div class="card-body">
                        <h5>Total Listings</h5>
                        <p class="fs-4">${totalListings}</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-center summary-card">
                    <div class="card-body">
                        <h5>Items Sold</h5>
                        <p class="fs-4">${totalSold}</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-center summary-card">
                    <div class="card-body d-flex flex-column align-items-center justify-content-center">
                        <h5>Pending Approvals</h5>
                        <p class="fs-4">${pendingListings}</p>
                        <a href="${pageContext.request.contextPath}/admin/pending-listings" class="btn btn-dark mt-2 btn-sm summary-btn">View</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="row mt-4">
            <!-- Bar Chart -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header text-center fw-bold">Listings Overview</div>
                    <div class="card-body chart-container">
                        <canvas id="barChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Pie Chart -->
            <div class="col-md-6 mb-4">
                <div class="card">
                    <div class="card-header text-center fw-bold">Listing Status</div>
                    <div class="card-body chart-container">
                        <canvas id="pieChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Listings Table -->
        <h4 class="mt-4 mb-3">Recent Listings</h4>
        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Title</th>
                        <th>Seller</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Uploaded</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="listing" items="${recentListings}">
                        <tr>
                            <td>${listing.title}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty listing.user.username}">
                                        ${listing.user.username}
                                    </c:when>
                                    <c:otherwise>
                                        ${fn:substringBefore(listing.user.email, '@')}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>₹${listing.price}</td>
                            <td>${listing.availability}</td>
                            <td>${listing.createdAt}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/view-item/${listing.id}?source=pending" class="btn btn-sm btn-primary">View</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentListings}">
                        <tr><td colspan="6" class="text-center">No recent listings</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/includes/footer.jsp" %>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    const barChart = new Chart(document.getElementById('barChart'), {
        type: 'bar',
        data: {
            labels: ['Users', 'Listings', 'Sold Items'],
            datasets: [{
                label: 'Count',
                data: [${totalUsers}, ${totalListings}, ${totalSold}],
                backgroundColor: ['#0d6efd', '#198754', '#0dcaf0'],
                borderRadius: 8
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true }
            }
        }
    });

    const pieChart = new Chart(document.getElementById('pieChart'), {
        type: 'pie',
        data: {
            labels: ['Approved', 'Rejected', 'Pending'],
            datasets: [{
                data: [${approvedCount}, ${rejectedCount}, ${pendingListings}],
                backgroundColor: ['#28a745', '#dc3545', '#ffc107']
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            aspectRatio: 1.5,
            plugins: {
                legend: { position: 'bottom' }
            }
        }
    });
</script>

</body>
</html>
