"""Build the installable SpellStats ZIP using the version in the manifest."""
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo

root = Path(__file__).resolve().parents[1]
addon = root / "SpellStats"
manifest = (addon / "SpellStats.toc").read_text().splitlines()
version = next(line.removeprefix("## Version: ") for line in manifest if line.startswith("## Version: "))
entries = {path.relative_to(addon).as_posix(): path for path in addon.rglob("*") if path.is_file()}
for filename in ("LICENSE", "README.md", "icon.png"):
    entries[filename] = root / filename

archive = root / "dist" / f"SpellStats-{version}.zip"
archive.parent.mkdir(exist_ok=True)
with ZipFile(archive, "w") as release:
    for name, source in sorted(entries.items()):
        entry = ZipInfo("SpellStats/" + name)
        entry.create_system = 3
        entry.external_attr = 0o100644 << 16
        release.writestr(entry, source.read_bytes(), compress_type=ZIP_DEFLATED)
print(archive)
