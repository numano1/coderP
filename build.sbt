import scala.sys.process._

// Global settings
ThisBuild / scalaVersion := "2.13.8"
ThisBuild / version := scala.sys.process.Process("git rev-parse --short HEAD").!!.mkString.replaceAll("\\s", "") + "-SNAPSHOT"
ThisBuild / organization := "Chisel-blocks"

// Suppress eviction warnings
ThisBuild / evictionErrorLevel := Level.Info

val chiselVersion = "3.5.6"

// Top Module: qspi_master
lazy val qspi_master = (project in file("."))
  .aggregate(clockgen, rx, tx) // Aggregate submodules
  .settings(
    name := "qspi_master",
    libraryDependencies ++= Seq(
      "edu.berkeley.cs" %% "chisel3" % chiselVersion,
      "edu.berkeley.cs" %% "chiseltest" % "0.5.5" % "test"
    ),
    scalacOptions ++= Seq(
      "-language:reflectiveCalls",
      "-deprecation",
      "-feature",
      "-Xcheckinit",
      "-P:chiselplugin:genBundleElements",
      "-Ymacro-annotations"
    ),
    addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % chiselVersion cross CrossVersion.full)
  )

// Submodule: Clockgen
lazy val clockgen = (project in file("clockgen"))


// Submodule: Receiver
lazy val rx = (project in file("rx"))

// Submodule: Transceiver
lazy val tx = (project in file("tx"))
