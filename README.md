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


### 3. Fetch raylib package
First, install necessary dependency for raylib (see https://github.com/raysan5/raylib/wiki).

Second, fetch raylib package using `zig fetch`, where any repo contains a `build.zig` is consider a package. Fetching copies a package into the global cache and print its hash. 

```zig
zig fetch https://github.com/raysan5/raylib/archive/refs/tags/5.5.tar.gz
```
This command print the hash value for the next step. 

### 4. Add raylib as a dependency
Modify the `build.zig.zon` file to add raylib as a dependency. This is essential for the build system (and the LSP, I guess?) to be able to recognize the raylib source code. 

```zig
// build.zig.zon

.dependencies = .{
    .raylib = .{
        .url = "https://github.com/raysan5/raylib/archive/refs/tags/5.5.tar.gz", // the url for the source code
        .hash = "1220d93782859726c2c46a05450615b7edfc82b7319daac50cbc7c3345d660b022d7", // obtained from `zig fetch`
    },
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

### 7. Build the program
```bash
zig build run
```
If you use this repo code, you should see a window pop up after build complete. 

Congratulations!
