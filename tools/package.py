"""Validate SpellStats and build the installable ZIP and its release checksum."""
from hashlib import sha256
import json
from pathlib import Path
import struct
from tempfile import TemporaryDirectory
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo

from release import ROOT, metadata


def package_files(root, manifest):
    addon = root / "SpellStats"
    load_order = [line.strip() for line in manifest.splitlines()
                  if line.strip() and not line.lstrip().startswith("#")]
    if len(load_order) != len(set(load_order)):
        raise ValueError("Duplicate TOC load entry")

    vendor = "Libs/SomethingNeedDoing/"
    extras = {"SpellStats.toc", "THIRD-PARTY.txt", "Media/Icon.tga",
              vendor + "UPSTREAM.json", vendor + "LICENSE"}
    expected = set(load_order) | extras
    files = {p.relative_to(addon).as_posix(): p for p in addon.rglob("*") if p.is_file()}
    if files.keys() != expected:
        raise ValueError(f"Check package contents. Missing {expected - files.keys()}, extra {files.keys() - expected}")

    pin = json.loads(files[vendor + "UPSTREAM.json"].read_text(encoding="utf-8"))
    hashes = pin["sha256"]
    pinned_files = {n.removeprefix(vendor) for n in load_order if n.startswith(vendor)} | {"LICENSE"}
    if hashes.keys() != pinned_files:
        raise ValueError("The SND pin must cover the loaded library and license")
    for name, digest in hashes.items():
        if sha256(files[vendor + name].read_bytes()).hexdigest() != digest:
            raise ValueError(f"SND pin mismatch for {name}")

    for name in ("LICENSE", "README.md", "icon.png"):
        files[name] = root / name
    png = files["icon.png"].read_bytes()
    if not png.startswith(b"\x89PNG\r\n\x1a\n") or png[12:16] != b"IHDR":
        raise ValueError("Invalid public PNG icon")
    icon = files["Media/Icon.tga"].read_bytes()
    if len(icon) < 18 or icon[2] != 2:
        raise ValueError("Invalid in-game TGA icon")
    width, height, depth = struct.unpack_from("<HHB", icon, 12)
    if (width != height or width == 0 or width & (width - 1) or depth not in (24, 32)
            or len(icon) < 18 + icon[0] + width * height * (depth // 8)):
        raise ValueError("Invalid dimensions or incomplete pixel data in the in-game icon")
    return files


def build(root=ROOT):
    manifest = (root / "SpellStats/SpellStats.toc").read_text(encoding="utf-8")
    version = next((line.removeprefix("## Version: ") for line in manifest.splitlines()
                    if line.startswith("## Version: ")), "")
    release = metadata("v" + version, manifest)
    entries = package_files(root, manifest)
    dist = root / "dist"
    dist.mkdir(exist_ok=True)
    archive = dist / release["archive"]
    with TemporaryDirectory(dir=dist) as directory:
        candidate = Path(directory) / archive.name
        with ZipFile(candidate, "w") as package:
            for name, source in sorted(entries.items()):
                entry = ZipInfo("SpellStats/" + name)
                entry.create_system = 3
                entry.external_attr = 0o100644 << 16
                package.writestr(entry, source.read_bytes(), compress_type=ZIP_DEFLATED)
        with ZipFile(candidate) as package:
            bad = package.testzip()
            if bad:
                raise ValueError(f"ZIP integrity check failed for {bad}")
        digest = sha256(candidate.read_bytes()).hexdigest()
        checksum = Path(directory) / "SHA256SUMS"
        checksum.write_text(f"{digest}  {archive.name}\n", encoding="utf-8")
        candidate.replace(archive)
        checksum.replace(dist / checksum.name)
    return archive


if __name__ == "__main__":
    print(build())
