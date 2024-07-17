package com.topaz.service;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Base64;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.topaz.dto.ApprovalSign;
import com.topaz.dto.UploadFile;
import com.topaz.mapper.ApprovalMapper;
import com.topaz.utill.Debug;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ApprovalService {

	@Autowired ApprovalMapper approvalMapper;
	@Autowired UploadFileService uploadFileService;
	
	
	/*
	 * 분류 번호: #11 - 결재 서명 등록
	 * 시작 날짜: 2024-07-17
	 * 담당자: 박혜아
	*/
	public int setSign(String signImg, String empNo) throws Exception {
		
		log.debug(Debug.PHA + "setSign service signImg--> " + signImg + Debug.END);
		log.debug(Debug.PHA + "setSign service empNo--> " +empNo + Debug.END);
		
		// URL데이터 형식으로 가져왔으므로 Base64 디코딩 해주기
        String[] parts = signImg.split(","); // 데이터 부분과 MIME 타입 부분을 나눠주기 
        String base64Data = parts[1]; // 데이터 URL에서 base64 부분만 추출
        byte[] decodedBytes = Base64.getDecoder().decode(base64Data); // 디코딩하여 바이트 배열로 변환
        
        // uuid생성
        String filename = UUID.randomUUID().toString().replace("-", "") + ".png";
        log.debug(Debug.PHA + "setSign service filename--> " + filename + Debug.END);
        
        // approvalSign DTO 값 넣어주기
        ApprovalSign approvalSign = new ApprovalSign();
        approvalSign.setEmpNo(empNo);
        approvalSign.setRegId(empNo);
        approvalSign.setModId(empNo);
        approvalSign.setUseYn("Y");
        approvalSign.setFileName(filename);
        log.debug(Debug.PHA + "setSign service approvalSign--> " + approvalSign + Debug.END);
        
        // approval_sign 테이블에 서명 저장 
        int insertSign = approvalMapper.insertApprovalSign(approvalSign);
        if(insertSign != 1) {
			// 등록 실패시 예외 발생시키기
			log.debug(Debug.PHA + "insertSign에서 RuntimeException 발생! " + Debug.END);
			throw new RuntimeException();
		}
        
        // approval_sign에서 insert된 singNo가져오기
        String signNo = approvalSign.getSignNo();
        log.debug(Debug.PHA + "setSign service signNo--> " + signNo + Debug.END);
        
        // 파일 업로드 DTO세팅
        UploadFile file = new UploadFile();
        file.setReferenceNo(signNo);
        file.setOriginalFileName(filename);
        file.setFileName(filename);
        file.setFileSize(decodedBytes.length);
        file.setFileType("png");
        file.setRegId(empNo);
        file.setModId(empNo);
        file.setUseYN("Y");
        
        // file_upload테이블에 저장
        int insertFile = approvalMapper.insertApprovalSignFile(file);
        if(insertFile != 1) {
			// 등록 실패시 예외 발생시키기
			log.debug(Debug.PHA + "insertFile에서 RuntimeException 발생! " + Debug.END);
			throw new RuntimeException();
		}
		
        // 파일 폴더에 저장
        File emptyFile = new File(System.getProperty("user.dir") 
									+ "/src/main/resources/static/assets/img/approvalSign/" 
									+ filename);
        
        // 파일로 저장 시키기
        try {
        	FileOutputStream fileOutputStream = new FileOutputStream(emptyFile);
            fileOutputStream.write(decodedBytes); // 디코딩된 이미지 데이터를 파일에 기록합니다.
            fileOutputStream.close();
		} catch (Exception e) {
			log.debug(Debug.PHA + "emptyFile 파일저장에서 Exception 발생! " + Debug.END);
			e.printStackTrace(); // 예외나면 전부 취소
			throw new RuntimeException(); // 일부러 예외를 발생시켜서 위에도 했던 insert명령도 전부 취소
		}
        
		return insertSign + insertFile;
	}
	
	
	
}
