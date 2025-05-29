//
//  CreateView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftUI

struct CreateView: View {
    @State private var projectName: String = ""
    @State private var showProjectSelector = false
    @State private var isPresentingCamera = false
    @State private var descriptionText: String = ""
    @State private var showPlaceholder: Bool = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // MARK: 프로젝트명

                Button(action: {
                    showProjectSelector = true
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("프로젝트명")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                    }
                }
                
                TextField("프로젝트명을 적어주세요", text: $projectName)
                    .font(.system(size: 14))
                    .submitLabel(.done)
                    .padding(.vertical, 8)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray),
                        alignment: .bottom
                    )
                
                // MARK: 날짜 선택

                VStack(alignment: .leading) {
                    Text("과정 기록일")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.bottom, 8)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.system(size: 16))
                        
                        Text("오늘, 4월 11일 (금)")
                            .font(.system(size: 14))
                    }
                    .foregroundColor(.black)
                    Divider()
                        .background(Color.gray)
                }
                .padding(.vertical, 16)
                
                // MARK: 사진 업로드

                VStack(alignment: .leading) {
                    Text("진행 과정")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.bottom, 8)
                    
                    VStack(spacing: 28) {
                        Button(action: {
                            isPresentingCamera = true
                        }) {
                            VStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 64, height: 64)
                                    .background(Color.yellow)
                                    .clipShape(Circle())
                                    .padding(.bottom, 16)
                                
                                Text("과정의 기록을 보여줄 수 있는 사진을 올려주세요")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.vertical, 56)
                    }
                    .frame(maxWidth: .infinity) // 가운데 정렬
                }
                
                // MARK: 설명 입력

                VStack(alignment: .leading) {
                    Text("과정에 관한 설명")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.bottom, 8)
                    
                    ZStack(alignment: .topLeading) {
                        if descriptionText.isEmpty {
                            Text("과정에 대하여 남기고 싶은 내용이 있으면 적어주세요")
                                .foregroundColor(.gray)
                                .padding(.top, 12)
                                .padding(.leading, 8)
                                .font(.system(size: 14))
                        }
                        
                        // 실제 입력창
                        TextEditor(text: $descriptionText)
                            .padding(8)
                            .font(.system(size: 14))
                            .scrollContentBackground(.hidden)
                            .frame(height: 120)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                    }
                }
                .padding(.vertical, 16)
                
                // MARK: 작성 완료 버트

                Button(action: {
                    // 작성 완료 동작
                }) {
                    Text("작성 완료")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.yellow)
                        .cornerRadius(8)
                }
            }
            .fullScreenCover(isPresented: $isPresentingCamera) {
                CameraView()
            }
            .sheet(isPresented: $showProjectSelector) {
                ProjectSelectorView()
                    .presentationDetents([.medium, .large])
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    CreateView()
}
