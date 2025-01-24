<!-- # Raylib-in-Zig
Use raylib in Zig without bindings, just build from source.

**Zig version: 0.13**
**raylib version: 5.5**

## Why raylib in Zig
With only miminal background in C/C++, I have 0 idea on C buidling system (Make, Cmake, etc...). After one scucess build, I am exhausted and gave up. 

Utill I started to learn [Zig](https://ziglang.org/), which is a project tries to be THE successor of C by providing a simlple building system supporting existing C/C++ code, and a new system-level lanuage with morden features.

In order to learn Zig programming, and how to use exsiting c libraries in Zig, I pick back up raylib again.  As Zig is new and lack online post or detailed documantation (I found a few resources about raylib on zig but only work on old versions of Zig/raylib), I make this repo as an example on how to use raylib in Zig without bindings, but just build it from source. Hope others can find this helpful too.

P.S. I am new to Zig, idk is there a better way, but this seems simple to me. 

## Steps
Here ae the step up process to use raylib (or even other c libraries).

### 1. Install Zig
Install Zig to your environment following [the installation steps](https://zig.guide/getting-started/installation/) from zig.guide.

## 2. Clone this repo / Start from scracth
**Option 1**: You can clone this repo and floowing Step 3 and good to go.
```bash
git clone https://github.com/ptpyip/Raylib-in-Zig.git
cd Raylib-in-Zig
```
This repo is generated from running `zig init` with some modification.

**Option 2**: Start from scracth by running `zig init`
```bash
mkdir Raylib-in-Zig
cd Raylib-in-Zig
zig init
```

## 3. Clone raylib
Clone raylib repo to `./lib` diractory, or anywhere in your like and make sure it is visable under `./lib` by copying or soft links. \
As we are going to build programme with raylib from scracth, there is no need to install raylib.
```bash
cd ./lib
git clone https://github.com/raysan5/raylib.git
```

If u cloned this repo you can build and run the program using `zig build run`.

Note: the name of `./lib` diractory can be changed as long as u change the `build.zig.zon` file as well. I am not sure about the best parctice for zig (may be none?). Feel free to change it to other names you prefer for a zig project like `./dep`.

## 4. Add raylib as dependencies
Here we modify the `build.zig.zon` file to add raylib as dependencies. This is essential for the buiding system (and the lsp I guess?) to be able to regonize the raylib source code.

```zig
// build.zig.zon

.dependencies = .{
    .raylib = .{ .path = "./lib/raylib/" },    
    // syntax: .<lib_name> = .{ .path = <relative_path_to_source_code> }
}
```

## 5. Add build steps in `build.zig`
Following a PR in Zig offical repo (https://github.com/raysan5/raylib/pull/4475), here is the code to link raylib as dendency.
```zig
    // inside build function

    const exe = b.addExecutable(.{
        .name = "tmp",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    // declare the dependancies need to be linked
    const raylib_dep = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
        // set options here for external library
        .shared = true,
    });
    const raylib = raylib_dep.artifact("raylib");

    exe.linkLibC();
    exe.linkLibrary(raylib);    // link raylib to src programe

    const run_cmd = ...
    // more build code below
```
Note: Online resources used `addRaylib` before, but it is removed (see https://github.com/raysan5/raylib/pull/4475). Now it is rely on adding raylib as dependency, indicating the build system to build raylib, which I think is a W for Zig as it is more seamless to begineers. That said, I beleive ones can still write all the build code by hand and make it work.

## 6. import Raylib
```  zig
const ray = @cImport({
    @cInclude("raylib.h");
});
```
By adding this line to your zig programme, you can now use raylib in Zig. -->

# Raylib-in-Zig
Use raylib in Zig without bindings, just build from source.

**Zig version: 0.13**  
**raylib version: 5.5**

## Why raylib in Zig
With only minimal background in C/C++, I have zero idea about C build systems (Make, CMake, etc.). After one successful build, I was exhausted and gave up.

Until I started to learn [Zig](https://ziglang.org/), which is a project that aims to be the successor of C by providing a simple build system supporting existing C/C++ code, and a new system-level language with modern features.

In order to learn Zig programming and how to use existing C libraries in Zig, I picked up raylib again. As Zig is new and lacks online posts or detailed documentation (I found a few resources about raylib on Zig but they only work on old versions of Zig/raylib), I made this repo as an example of how to use raylib in Zig without bindings, but just build it from source. I hope others can find this helpful too.

P.S. I am new to Zig, so I don't know if there is a better way, but this seems simple to me.

## Steps
Here are the steps to use raylib (or even other C libraries).

### 1. Install Zig
Install Zig to your environment following [the installation steps](https://zig.guide/getting-started/installation/) from zig.guide.

### 2. Clone this repo / Start from scratch
**Option 1**: You can clone this repo and follow Step 3 to get started.
```bash
git clone https://github.com/ptpyip/Raylib-in-Zig.git
cd Raylib-in-Zig
```
This repo is generated from running `zig init` with some modifications.

**Option 2**: Start from scratch by running `zig init`
```bash
mkdir Raylib-in-Zig
cd Raylib-in-Zig
zig init
```

### 3. Clone raylib
Clone the raylib repo to the `./lib` directory, or anywhere you like, and make sure it is visible under `./lib` by copying or using soft links. \
As we are going to build the program with raylib from scratch, there is no need to install raylib.
```bash
cd ./lib
git clone https://github.com/raysan5/raylib.git
```

If you cloned this repo, you can build and run the program using `zig build run`.

Note: The name of the `./lib` directory can be changed as long as you change the `build.zig.zon` file as well. I am not sure about the best practice for Zig (maybe none?). Feel free to change it to other names you prefer for a Zig project like `./dep`.

### 4. Add raylib as a dependency
Modify the `build.zig.zon` file to add raylib as a dependency. This is essential for the build system (and the LSP, I guess?) to be able to recognize the raylib source code.

```zig
// build.zig.zon

.dependencies = .{
    .raylib = .{ .path = "./lib/raylib/" },    
    // syntax: .<lib_name> = .{ .path = <relative_path_to_source_code> }
}
```

### 5. Add build steps in `build.zig`
Following a PR in the Zig official repo (https://github.com/raysan5/raylib/pull/4475), modify `build.zig` to add build steps for raylib (zig will automatically use `raylib/build.zig` to help compile raylib).

```zig
    // inside build function

    const exe = b.addExecutable(.{
        .name = "tmp",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    // declare the dependencies that need to be linked
    const raylib_dep = b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
        // set options here for the external library
        .shared = true,
    });
    const raylib = raylib_dep.artifact("raylib");

    exe.linkLibC();
    exe.linkLibrary(raylib);    // link raylib to the executable

    const run_cmd = ...
    // more build code below
```
Note: Online resources used `addRaylib` before, but it has been removed (see https://github.com/raysan5/raylib/pull/4475). Now it relies on adding raylib as a dependency, indicating the build system to build raylib, which I think is a win for Zig as it is more seamless for beginners. That said, I believe one can still write all the build code by hand and make it work.

### 6. Import Raylib
```zig
const ray = @cImport({
    @cInclude("raylib.h");
});
```
By adding this line to your Zig program, you can now use raylib in Zig.
