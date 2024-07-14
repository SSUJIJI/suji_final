<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!--
   분류 번호: #10 - 공지 사항 등록 페이지
   시작 날짜: 2024-07-05
   담당자: 김지훈
-->    
<!DOCTYPE html>
<html lang="ko">
<head>
	<!-- CSS / JS -->
	<link href="/topaz/css/jihoon.css" rel="stylesheet">
	<script src="/topaz/js/jihoonNoticeAdd.js"></script>
	<!-- naver smart edior -->
	<script type="text/javascript" src="/topaz/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>
	 <script>
        // JSP에서 contextPath 값을 JavaScript로 넘김
        const contextPath = '<%= request.getContextPath() %>';
    </script>
	<script>
		let oEditor = [];
		function initSmartEditor() {
			nhn.husky.EZCreator.createInIFrame({
				oAppRef: oEditor,
				elPlaceHolder: "content", // 에디터가 삽입될 위치 == textarea의 id
				sSkinURI: "/topaz/smarteditor/SmartEditor2Skin.html",
				fCreator: "createSEditor2"
			});
			
		}
        function submitContent(form) {
            // 폼 전송 전에 에디터의 내용을 textarea에 넣기
            oEditor.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
            
         	// 에디터에서 내용 가져오기
            const content = oEditor.getById["content"].getIR();
            	console.log("#content: ", content);
            
            if (!content.trim()) {
                alert("내용을 입력해 주세요.");
                return false; // 폼을 제출하지 않습니다.
            }
				return true;
        }
		
		// 문서 로드 후 스마트 에디터 초기화
		document.addEventListener("DOMContentLoaded", function() {
			initSmartEditor();
			console.log("스마트 에디터 초기화");
		});
	</script>
</head>
	<!-- ======= header <Head> 부분 ======= -->
	<jsp:include page="/WEB-INF/view/groupware/inc/headerHead.jsp"></jsp:include>
	
	<body>
		<!-- ======= header <Body> 부분 ======= -->
		<jsp:include page="/WEB-INF/view/groupware/inc/hearderBody.jsp"></jsp:include>
		
		<!-- ======= sideBar 부분 ======= -->
		<jsp:include page="/WEB-INF/view/groupware/inc/sideBar.jsp"></jsp:include>
	
		<!-- =============================== Main 메인 시작 부분 ================================ -->
		<main id="main" class="main">
		
		    <div class="pagetitle">
		      <h1>공지 사항</h1>
		    </div>
	
			<section class="section">
				<div class="row">
					<div class="col-lg-10">
						<div class="card">
							<div class="card-body">
								<h5 class="card-title">공지 사항 작성</h5>
								<form action="<c:url value="${contextPath}/groupware/notice/noticeAdd" />" method="post" id="addNoticeForm" onsubmit="return submitContent(this);" enctype="multipart/form-data">
									<div class="row mb-3">
										<label for="addTitle" class="col-sm-2 col-form-label">제목</label>
										<div class="col-sm-10">
											<input type="text" class="form-control" id="title" name="title">
										</div>
										<span>${titleMsg }</span>
									</div>
									<fieldset class="row mb-3">
										<legend class="col-form-label col-sm-2 pt-0">등급</legend>
										<div class="col-sm-10">
											<div class="form-check">
												<input class="form-check-input addGrade" type="radio" name="grade" id="addGrade1" value="1">
												<label class="form-check-label" for="addGrade1">
													직원 
												</label>
											</div>
											<div class="form-check">
												<input class="form-check-input addGrade" type="radio" name="grade" id="addGrade2" value="2">
												<label class="form-check-label" for="addGrade2">
													외주 업체 
												</label>
											</div>
										</div>
										<span>${gradeMsg }</span>
									</fieldset>
									
									<fieldset class="row mb-3">
										<legend class="col-form-label col-sm-2 pt-0">종류</legend>
										<div class="col-sm-10">
											<div class="form-check">
												<input class="form-check-input addCategory" type="radio" name="category" id="addCategory1" value="1">
												<label class="form-check-label" for="addCategory1">
													필독 
												</label>
											</div>
											<div class="form-check">
												<input class="form-check-input addCategory" type="radio" name="category" id="addCategory2" value="2">
												<label class="form-check-label" for="addCategory2">
													일반
												</label>
											</div>
											<div class="form-check">
												<input class="form-check-input addCategory" type="radio" name="category" id="addCategory3" value="3">
												<label class="form-check-label" for="addCategory">
													이벤트 
												</label>
											</div>
										</div>
										<span>${categoryMsg }</span>
									</fieldset>
									<!-- start date -->
									<div class="row mb-3">
										<label for="noticeStart" class="col-sm-2 col-form-label">
											게시 시작일
										</label>
										<div class="col-sm-4">
											<input type="date" class="form-control" id="startDate" name="startDate">
										</div>
									</div>
									<!-- end date-->
									<div class="row mb-3">
										<label for="noticeEnd" class="col-sm-2 col-form-label">
											게시 종료일
										</label>
										<div class="col-sm-4">
											<input type="date" class="form-control" id="endDate" name="endDate">
										</div>
									</div>
									
									<div class="row mb-3">
										<label for="content" class="col-sm-2 col-form-label">
											내용
								
										</label>
										<div class="col-sm-10">
											<textarea class="form-control" style="height: 100px" name="content" id="content"></textarea>
										</div>
										<span>${contentMsg }</span>
									</div>
									<div class="row mb-3">
										<input type="file" name="uploadFile" id="uploadFile">
									    <div id="previewContainer" class="imagePreviewContainer" style="display:none;">
									        <img id="preview">
									        <span id="removeImage" class="removeImage">&times;</span>
									    </div>
							    	</div>
								<button type="button" class="btn btn-primary" onclick="location.href='/topaz/groupware/notice/noticeList'">목록</button>	
								<button type="submit" class="btn btn-primary" onclick="formSubmit(event)">등록하기</button>
								</form>
								<!-- End General Form Elements -->
							</div>
						</div>
					</div>
				</div>
			</section>
	
		</main><!-- End #main -->
		
		<!-- =============================== Main 메인 끝 부분 ================================ -->
		
		<!-- ======= footer 부분 ======= -->
		<jsp:include page="/WEB-INF/view/groupware/inc/footer.jsp"></jsp:include>
		<script src="/topaz/js/profileValidation.js"></script>
	</body>
</html>