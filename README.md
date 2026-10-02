## 🐧 Shrinkit - Image and Video optimizer

![GitHub top language](https://img.shields.io/github/languages/top/zappee/shrinkit)
![GitHub Issues](https://img.shields.io/github/issues/zappee/shrinkit)
![GitHub Release](https://img.shields.io/github/v/release/zappee/shrinkit)

#### ⭐⭐ Like this project? Support my work by giving it a star on [GitHub](https://github.com/zappee/file-backup-restore/) ⭐⭐

![GitHub Repo stars](https://img.shields.io/github/stars/zappee/file-backup-restore?style=flat)

**Shrinkit** is a collection of lightweight automation tools designed to drastically reduce the size of media files (images and videos) taken on your mobile phone, making them easier to store, share, and back up without sacrificing noticeable quality.

### 1) Features

- **Video compression:** Squash massive 4K or 1080p phone clips so they stop eating up your storage.
- **Image optimization:** Batch-compress your pictures to free up hard drive space and make them small enough to email or share instantly.
- **Safe or Overwrite modes:** Keep your original files as a backup by default, or replace them instantly and free up storage.
- **Batch processing:** Pass a whole folder at once to compress all your media in one go instead of doing it file-by-file.

### 2) Installation & Requirements
This project relies on two external command-line tools to handle the compression:
- **FFmpeg:** for video compression
- **mogrify:** part of _ImageMagick_, used for image optimization

Make sure you have both installed on your system before running the scripts.

```bash
$ sudo apt update
$ sudo apt install ffmpeg imagemagick
```

### 3) Usage instructions

#### 3.1) Video reduction

The video reducer script scans a target directory and compresses the videos found inside.

```bash
$ ./video-shrinker.sh <directory> [overwrite]
```

**Parameters:**
- `<directory>`: The absolute or relative path to the folder containing your video files.
- `[overwrite]`: Optional, set to `true` to replace the original large videos with compressed ones. Set to `false` to preserve your original files. Default: `false`

**Examples:**

- **Safe Mode (recommended):** Compresses videos but preserves your original files as a backup.
  ```bash
  $ ./video-shrinker.sh /home/$USER/Videos/
  ```

- **Overwrite mode:** Automatically replaces original video files to immediately free up space.
  ```bash
  $ ./video-shrinker.sh /home/$USER/Videos/ true
  ```

  When initialized, the script provides a clean confirmation summary of your execution targets:

  ```text
  Configuration:
    Working directory:   "/home/<user>/Videos/"
    Overwrite originals: false
    Files Selected:      2
  ```

#### 3.2) JPG photo reduction

Compresses a whole folder of images at once, making them much lighter.

```bash
$ ./jpg-shrinker.sh <directory> [overwrite]
```

**Parameters:**
- `<directory>`: The path to the folder containing your JPG images.
- `[overwrite]`: Optional, set to `true` to compress the photos directly in place. Set to `false` to keep your original images intact. Default: `false`

**Examples:**

- **Safe Mode (recommended):** Processes copies of your pictures so your originals stay untouched.
  ```bash
  $ ./jpg-shrinker.sh /home/$USER/Pictures/
  ```

- **Overwrite Mode:** Overwrites the photos in place to immediately clear out storage.
  ```bash
  $ ./jpg-shrinker.sh /home/$USER/Pictures/ true
  ```

  When initialized, either script will output a clear summary of your settings before starting:

  ```text
  Configuration:
    Working directory:   "/home/<user>/Pictures/"
    Overwrite originals: false
  ```

### 🤝 Contributing

Contributions, feature requests, optimization, and bug reports are always welcome!
For more information, please visit my [homepage](https://zappee.github.io).
