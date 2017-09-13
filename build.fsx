(* -- Fake Dependencies paket-inline
source https://nuget.org/api/v2

nuget Fake.Core.Targets prerelease
nuget Fake.Core.Globbing 
nuget Fake.IO.FileSystem
nuget Fake.DotNet.MsBuild
nuget NUnit.ConsoleRunner
-- Fake Dependencies -- *)

#load "./.fake/build.fsx/intellisense.fsx"
#r @".\.fake\build.fsx\packages\Fake.Core.Targets\lib\netstandard1.6\Fake.Core.Targets.dll"
#r @".\.fake\build.fsx\packages\Fake.Core.Globbing\lib\netstandard1.6\Fake.Core.Globbing.dll"
#r @".\.fake\build.fsx\packages\Fake.IO.FileSystem\lib\netstandard1.6\Fake.IO.FileSystem.dll"
#r @".\.fake\build.fsx\packages\Fake.DotNet.MsBuild\lib\netstandard1.6\Fake.DotNet.MsBuild.dll"

open Fake.Core
open Fake.Core.TargetOperators
open Fake.Core.Globbing.Operators
open Fake.IO
let buildDir = "build"
let buildBinDir = buildDir + "/bin"
let solutionPath = "sample-web-api.sln"

Target.Create "Clean" <| fun _ ->
     

Target.Create "Restore-NuGet-Packages" <| fun _ ->
    printfn "Restore-NuGet-Packages"

Target.Create "Build" <| fun _ ->
    printfn "Build"

Target.Create "Run-Unit-Tests" <| fun _ ->
    printfn "Run-Unit-Tests"

Target.Create "Default" <| fun _ ->
    printfn "Default"

"Clean" ==> "Restore-NuGet-Packages" ==> "Build" ==> "Run-Unit-Tests" ==> "Default"

Target.RunOrDefault "Default"
