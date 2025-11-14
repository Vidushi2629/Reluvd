<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile | ReLuvd</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

	<jsp:include page="/load-sidebar" />
	

<!-- Main Content -->
<div class="main-content">
	<%@ include file="/WEB-INF/views/includes/header.jsp" %>
    <form class="profile-wrapper" method="post" action="${pageContext.request.contextPath}/update-profile" enctype="multipart/form-data">
        <div class="profile-left">
            <div class="profile-box">


				     <label>Profile Picture:</label>
				     <input type="file" name="profilePic"/>
				<c:if test="${not empty user.profilePictureUrl}">
				            <button 
				                type="button" 
				                class="btn mb-3" 
				                style="background-color: #244C45; color: white;" 
				                onclick="removeProfilePicture()">
				                Remove Profile Picture
				            </button>
				        </c:if>


                <label>Email:</label>
               <input type="email" value="<c:out value='${user.email}'/>" readonly/>
			   
			   <div class="form-group">
			       <label for="username">Username</label>

			       <c:if test="${param.error == 'usernameTaken'}">
			           <div class="text-danger small mb-1">
			               Username is already taken. Please choose another.
			           </div>
			       </c:if>

			       <input type="text" id="username" name="username" value="${user.username}" class="form-control"/>

			   </div>


                <label>Phone Number:</label>
				<input type="text" name="phone" value="${user.phone}" readonly/>

                <label>Date of Birth:</label>
				<div id="dob-error" class="text-danger small mt-1"></div>
                <input type="date" name="dob" value="${user.dob}"/>
				
                <label>Gender:</label>
                <select name="gender">
                    <option ${user.gender == null ? 'selected' : ''}>Select Gender</option>
                    <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                    <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                    <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Other</option>
                </select>
            </div>
        </div>

        <div class="profile-right">
            <div class="profile-box">
				<label>Addresses: <span style="color: red;">*</span></label>
				<div id="address-error" class="text-danger small mt-1"></div>
				<div class="address-list" id="addressList">
					<c:forEach var="addr" items="${user.addresses}">
					    <div class="address-item">
					       
							<input type="text"
							value="${addr.addressType}, ${addr.firstName}, ${addr.lastName}, ${addr.flatNumber}, ${addr.buildingName}, ${addr.landmark}, ${addr.street}, ${addr.city}, ${addr.state}, ${addr.zipcode}, ${addr.country}"readonly/>


					        <button type="button" onclick="toggleEditAddress(this)" title="Edit">
					            <i class="fas fa-pen"></i>
					        </button>
					        <button type="button" onclick="deleteAddress(this)" title="Delete">
					            <i class="fas fa-trash-alt"></i>
					        </button>
					    </div>
					</c:forEach>

				</div>
				<button type="button" class="add-btn" onclick="addAddress()">+ Add Address</button>

            </div>
        </div>

        <div class="button-bar">
			<button type="button" class="btn-primary" onclick="saveProfile()">Save Changes</button>
			<button type="button" class="btn-danger" onclick="deactivateAccount()">Deactivate Account</button>
			<button type="button" class="btn-logout" onclick="logout()">Logout</button>

        </div>
    </form>
</div>



<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
<script>
	const basePath = "/ReLuvd";
	async function saveProfile() {
		    const usernameInput = document.querySelector('input[name="username"]');
		    const username = usernameInput.value.trim();
		    const profilePicInput = document.querySelector('input[name="profilePic"]');
		    const addressItems = document.querySelectorAll('#addressList .address-item');
		    const formData = new FormData();

		    formData.append("username", username);

		    const dobInput = document.querySelector('input[name="dob"]');
		    const dob = dobInput.value;
		    const gender = document.querySelector('select[name="gender"]').value;

		    const dobError = document.getElementById("dob-error");
		    const addressError = document.getElementById("address-error");
		    const usernameError = document.getElementById("username-error");

		    // Clear all old error messages
		    dobError.textContent = "";
		    addressError.textContent = "";

		    if (dob) formData.append("dob", dob);
		    if (gender && gender !== "Select Gender") formData.append("gender", gender);

		    let atLeastOneAddress = false;

		    addressItems.forEach((item) => {
		        const field = item.querySelector("input");
		        const fieldValue = field ? field.value.trim() : "";

		        if (fieldValue && fieldValue.split(",").length >= 11) {
		            formData.append("addresses", fieldValue);
		            atLeastOneAddress = true;
		        }
		    });

		    if (!atLeastOneAddress) {
		        addressError.textContent = "Please add at least one complete address.";
		        return;
		    }

		    if (profilePicInput && profilePicInput.files.length > 0) {
		        formData.append("profilePic", profilePicInput.files[0]);
		    }

			const isValidDOB = validateDOB();
			const isValidUsername = await validateUsernameUnique();

			if (!isValidDOB) return;
			if (!isValidUsername) return;

		    fetch(basePath + "/update-profile", {
		        method: "POST",
		        body: formData
		    })
			.then(res => res.json())
			.then(data => {
			    if (data.redirect) {
			        window.location.href = data.redirect;
			    } else {
			        console.log("No redirect provided in response");
			    }
			})
			.catch(err => {
			    console.error("Fetch failed:", err);
			});
		}

		function logout() {
		    fetch('/ReLuvd/logout') 
		        .then(() => {
		            window.location.href = '/ReLuvd/';
		        })
		}




	function validateDOB() {
	    const dobInput = document.querySelector('input[name="dob"]');
	    const dobValue = dobInput.value.trim();
	    const today = new Date();
	    const dobDate = new Date(dobValue);
	    const dobError = document.getElementById("dob-error");

	    dobError.textContent = ""; // Clear previous error

	    if (dobDate >= today) {
	        dobError.textContent = "Date of Birth must be in the past.";
	        return false;
	    }

	    let age = today.getFullYear() - dobDate.getFullYear();
	    const m = today.getMonth() - dobDate.getMonth();
	    if (m < 0 || (m === 0 && today.getDate() < dobDate.getDate())) {
	        age--;
	    }

	    if (age < 18) {
	        dobError.textContent = "You must be at least 18 years old.";
	        return false;
	    }

	    return true;
	}

	async function validateUsernameUnique() {
	    const usernameInput = document.getElementById("username");
	    const newUsername = usernameInput.value.trim();

	    try {
			const response = await fetch(basePath+"/check-username?username="+newUsername);

	        if (!response.ok) {
	            throw new Error("Server returned error status.");
	        }

	        const available = await response.json();
	        return available; 

	    } catch (error) {
	        console.error("Error while checking username:", error);
	        return false;
	    }
	}

	document.addEventListener("DOMContentLoaded", () => {
	    const usernameInput = document.getElementById("username");
	    if (usernameInput) {
	        usernameInput.addEventListener("blur", async () => {
	            const valid = await validateUsernameUnique();
	            // just warn silently here if needed
	            console.log("Username available?", valid);
	        });
	    }
	});
    function addAddress() {
        const container = document.getElementById("addressList");
        const div = document.createElement("div");
        div.className = "address-item";

        div.innerHTML = `
            <input type="text" placeholder="Address Type, FirstName, LastName, Flat Number, Building Name, Landmark, Street, City, State, Zipcode, Country" readonly/>
            <button type="button" onclick="toggleEditAddress(this)" title="Edit">
                <i class="fas fa-pen"></i>
            </button>
            <button type="button" onclick="deleteAddress(this)" title="Delete">
                <i class="fas fa-trash-alt"></i>
            </button>
        `;
        container.appendChild(div);
    }

    function deleteAddress(button) {
        const container = button.closest(".address-item");
        const next = container.nextElementSibling;
        container.remove();
        if (next && next.classList.contains("edit-address-wrapper")) next.remove();
    }
	function toggleEditAddress(button) {
	    const container = button.closest(".address-item");
	    const addressList = container.parentElement;
	    const oldInput = container.querySelector("input");

	    oldInput.style.display = "none";
	    button.style.display = "none";

	    const deleteBtn = container.querySelector("button[title='Delete']");
	    if (deleteBtn) deleteBtn.style.display = "none";

	    const oldValues = oldInput.value.split(",").map(v => v.trim());
	    const labels = ["Address Type","First Name","Last Name","Flat Number","Building Name","Landmark","Street","City","State","Zipcode","Country"];
	    const requiredFields = ["Address Type","First Name","Last Name","Flat Number","Building Name","Street","City","State","Zipcode","Country"];

	    const inputs = [], errorDivs = [];

	    const formGrid = document.createElement("div");
	    formGrid.className = "edit-address-grid";
	    formGrid.style.display = "grid";
	    formGrid.style.gridTemplateColumns = "1fr 1fr";
	    formGrid.style.gap = "1rem";

	    labels.forEach((label, i) => {
	        const wrapper = document.createElement("div");
	        wrapper.className = "field-group";
	        wrapper.style.display = "flex";
	        wrapper.style.flexDirection = "column";
	        wrapper.style.marginBottom = "1rem";

	        const lbl = document.createElement("label");
	        lbl.innerHTML = label + (requiredFields.includes(label) ? ' <span style="color:red">*</span>' : '');
	        wrapper.appendChild(lbl);

	        const input = document.createElement("input");
	        input.placeholder = label;
	        input.className = "address-edit-field form-control";
	        input.value = oldValues[i] || "";
	        input.dataset.label = label; 
	        inputs.push(input);
	        wrapper.appendChild(input);

	        const error = document.createElement("div");
	        error.className = "text-danger small mb-1";
	        error.style.display = "none";
	        wrapper.appendChild(error);
	        errorDivs.push(error);

	        formGrid.appendChild(wrapper);
	    });

	    const saveBtn = document.createElement("button");
	    saveBtn.type = "button";
	    saveBtn.className = "save-btn";
	    saveBtn.innerHTML = `<i class="fas fa-save"></i> Save`;

	    saveBtn.onclick = () => {
	        let isValid = true;
	        inputs.forEach((input, idx) => {
	            const label = input.dataset.label; 
	            if (requiredFields.includes(label) && input.value.trim() === "") {
					errorDivs[idx].textContent = `This ${label} field is required.`;

	                errorDivs[idx].style.display = "block";
	                isValid = false;
	            } else {
	                errorDivs[idx].style.display = "none";
	            }
	        });

	        if (!isValid) return;

	        const values = inputs.map(i => i.value.trim());
	        oldInput.value = values.join(", ");
	        oldInput.style.display = "";
	        button.style.display = "";
	        if (deleteBtn) deleteBtn.style.display = "";
	        wrapperDiv.remove();
	    };

	    const cancelBtn = document.createElement("button");
	    cancelBtn.type = "button";
	    cancelBtn.className = "btn-danger";
	    cancelBtn.innerHTML = `<i class="fas fa-times"></i> Cancel`;

	    cancelBtn.onclick = () => {
	        oldInput.style.display = "";
	        button.style.display = "";
	        if (deleteBtn) deleteBtn.style.display = "";
	        wrapperDiv.remove();
	    };

	    const btnRow = document.createElement("div");
	    btnRow.className = "address-button-row";
	    btnRow.style.display = "flex";
	    btnRow.style.gap = "1rem";
	    btnRow.style.marginTop = "1rem";
	    btnRow.appendChild(saveBtn);
	    btnRow.appendChild(cancelBtn);

	    const wrapperDiv = document.createElement("div");
	    wrapperDiv.className = "edit-address-wrapper";
	    wrapperDiv.appendChild(formGrid);
	    wrapperDiv.appendChild(btnRow);

	    addressList.insertBefore(wrapperDiv, container.nextSibling);
	}    
	function deactivateAccount() {
	  if (!confirm("Are you sure you want to deactivate your account?")) return;

	  fetch("/ReLuvd/deactivate-account", {
	    method: "POST"
	  })
	    .then(res => {
	      if (!res.ok) throw new Error("Request failed");
	      return res.json();
	    })
	    .then(data => {
	      if (data.success) {
	        alert("Your account has been deactivated.");
	        window.location.href = basePath + "/";
	      } else {
	        alert(data.message || "Something went wrong.");
	      }
	    })
	    .catch(err => {
	      console.error("Error deactivating account:", err);
	      alert("Server error. Please try again.");
	    });
	}
	function removeProfilePicture() {
	        if (!confirm("Are you sure you want to remove your profile picture?")) return;

			fetch("/ReLuvd/remove-profile-picture", {
			    method: "POST"
			})
	            .then(res => {
	                if (!res.ok) throw new Error("Remove failed");
	                return res.json();
	            })
	            .then(data => {
	                if (data.success) {
	                    alert("Profile picture removed.");
	                    location.reload();
	                } else {
	                    alert("Failed to remove picture.");
	                }
	            })
	            .catch(err => {
	                console.error("Remove profile pic failed:", err);
	                alert("Error while removing picture.");
	            });
	    }


</script>


</body>
</html>
