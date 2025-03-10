allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Đặt build directory tùy chỉnh cho dự án của bạn
val customBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(customBuildDir)

// Chỉ override build directory cho các subprojects nằm trong thư mục gốc của dự án (không áp dụng cho các module ngoài như ở pub cache)
subprojects {
    // Kiểm tra nếu thư mục dự án của subproject bắt đầu bằng thư mục dự án gốc của bạn
    if (project.projectDir.absolutePath.startsWith(rootProject.projectDir.absolutePath)) {
        val newSubprojectBuildDir: Directory = customBuildDir.dir(project.name)
        project.layout.buildDirectory.value(newSubprojectBuildDir)
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
