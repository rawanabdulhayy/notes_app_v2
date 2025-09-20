<<<<<<< HEAD
=======
plugins {
    id("com.google.gms.google-services") version "4.4.3" apply false
}
>>>>>>> origin/main
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

<<<<<<< HEAD
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
=======
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
>>>>>>> origin/main
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
