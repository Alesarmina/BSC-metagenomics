#!/usr/bin/env bash
set -euo pipefail

# ========= PARÁMETROS =========
INPUT="subset_genefamilies.tsv"
UMAP="/space45/databases/humann3/utility_mapping"
OUTDIR="uniref_mapping_reducido"
mkdir -p "$OUTDIR"

echo "==> INPUT: $INPUT"
echo "==> UMAP : $UMAP"
echo "==> OUT  : $OUTDIR"
echo

# ========= AUTODETECTAR MAPAS =========
# UniRef90 -> Name (puede ser .bz2 o .gz)
NAME_MAP=$(ls -1 "$UMAP" | egrep -i '^map_uniref90_name\.txt\.(bz2|gz)$' | head -n1 || true)
[[ -n "${NAME_MAP:-}" ]] || { echo "ERROR: no encontré 'map_uniref90_name.txt.(bz2|gz)' en $UMAP"; exit 1; }

# UniRef90 -> KO
KO_MAP=$(ls -1 "$UMAP" | egrep -i '^map_ko_uniref90\.txt\.gz$' | head -n1 || true)
[[ -n "${KO_MAP:-}" ]] || { echo "ERROR: no encontré 'map_ko_uniref90.txt.gz' en $UMAP"; exit 1; }

# KO -> KO name
KO_NAME_MAP=$(ls -1 "$UMAP" | egrep -i '^map_ko_name\.txt\.gz$' | head -n1 || true)
[[ -n "${KO_NAME_MAP:-}" ]] || { echo "ERROR: no encontré 'map_ko_name.txt.gz' en $UMAP"; exit 1; }

# UniRef90 -> Level4EC (sustituto de UniRef->EC)
L4EC_MAP=$(ls -1 "$UMAP" | egrep -i '^map_level4ec_uniref90\.txt\.gz$' | head -n1 || true)
[[ -n "${L4EC_MAP:-}" ]] || { echo "ERROR: no encontré 'map_level4ec_uniref90.txt.gz' en $UMAP"; exit 1; }

# (Opcional) EC -> MetaCyc RXN si existe algún archivo que lo parezca
EC_RXN_MAP=$(ls -1 "$UMAP" | egrep -i 'metacyc.*rxn.*\.(txt|tsv)\.gz$' | head -n1 || true)

echo "   UniRef→Name : $NAME_MAP"
echo "   UniRef→KO   : $KO_MAP"
echo "   KO→Name     : $KO_NAME_MAP"
echo "   UniRef→L4EC : $L4EC_MAP"
if [[ -n "${EC_RXN_MAP:-}" ]]; then
  echo "   EC→MetaCyc  : $EC_RXN_MAP (opcional)"
else
  echo "   EC→MetaCyc  : NO DETECTADO (se omitirá este paso)"
fi
echo

# ========= CHECK INPUT =========
[[ -f "$INPUT" ]] || { echo "ERROR: falta $INPUT"; exit 1; }

# ========= LISTA ÚNICA DE UniRef90 =========
echo "==> Construyendo lista de UniRef90 presentes..."
awk -F'\t' 'NR>1 && $1 !~ /UNMAPPED|UNINTEGRATED/ {split($1,a,"|"); print a[1]}' "$INPUT" \
  | grep -E '^UniRef90_' \
  | LC_ALL=C sort -u > "$OUTDIR/uniref_list.txt"
echo "   UniRef90 únicos: $(wc -l < "$OUTDIR/uniref_list.txt")"
[[ -s "$OUTDIR/uniref_list.txt" ]] || { echo "ERROR: lista vacía"; exit 1; }

# ========= FUNCIONES AUX: grep comprimido =========
grep_list_to_file () {
  local list="$1" ; local archive="$2" ; local out="$3"
  case "$archive" in
    *.gz)  zgrep -F -f "$list" "$archive"  > "$out" ;;
    *.bz2) bzgrep -F -f "$list" "$archive" > "$out" ;;
    *)     echo "ERROR: extensión no soportada: $archive"; exit 1 ;;
  esac
}

# ========= UniRef → Name =========
echo "==> Reducción UniRef → Name..."
grep_list_to_file "$OUTDIR/uniref_list.txt" "$UMAP/$NAME_MAP" "$OUTDIR/uniref90_name_reduced.tsv"
awk -F'\t' 'NF>=2' "$OUTDIR/uniref90_name_reduced.tsv" > "$OUTDIR/.tmp" && mv "$OUTDIR/.tmp" "$OUTDIR/uniref90_name_reduced.tsv"
echo "   Filas (UniRef→Name): $(wc -l < "$OUTDIR/uniref90_name_reduced.tsv")"

# ========= UniRef → KO =========
echo "==> Reducción UniRef → KO..."
zgrep -F -f "$OUTDIR/uniref_list.txt" "$UMAP/$KO_MAP" > "$OUTDIR/uniref90_ko_reduced.tsv"
awk -F'\t' 'NF>=2' "$OUTDIR/uniref90_ko_reduced.tsv" > "$OUTDIR/.tmp" && mv "$OUTDIR/.tmp" "$OUTDIR/uniref90_ko_reduced.tsv"
echo "   Filas (UniRef→KO): $(wc -l < "$OUTDIR/uniref90_ko_reduced.tsv")"

# ========= KO → KO name =========
echo "==> Reducción KO → KO name..."
cut -f2 "$OUTDIR/uniref90_ko_reduced.tsv" | LC_ALL=C sort -u > "$OUTDIR/ko_list.txt"
zgrep -F -f "$OUTDIR/ko_list.txt" "$UMAP/$KO_NAME_MAP" > "$OUTDIR/ko_name_reduced.tsv"
echo "   Filas (KO→Name): $(wc -l < "$OUTDIR/ko_name_reduced.tsv")"

# ========= UniRef → Level4EC =========
echo "==> Reducción UniRef → Level4EC..."
zgrep -F -f "$OUTDIR/uniref_list.txt" "$UMAP/$L4EC_MAP" > "$OUTDIR/uniref90_level4ec_reduced.tsv"
awk -F'\t' 'NF>=2' "$OUTDIR/uniref90_level4ec_reduced.tsv" > "$OUTDIR/.tmp" && mv "$OUTDIR/.tmp" "$OUTDIR/uniref90_level4ec_reduced.tsv"
echo "   Filas (UniRef→Level4EC): $(wc -l < "$OUTDIR/uniref90_level4ec_reduced.tsv")"

# ========= (Opcional) EC → RXN MetaCyc =========
if [[ -n "${EC_RXN_MAP:-}" ]]; then
  echo "==> (Opcional) EC → RXN MetaCyc..."
  # Si algún día tienes UniRef→EC verdadero, aquí se usaría.
  # Con Level4EC no hay EC explícitas; por tanto, este paso se deja solo si existe un archivo EC→RXN.
  zcat "$UMAP/$EC_RXN_MAP" | head -n 1 >/dev/null 2>&1 || true
  echo "   Nota: como no tenemos UniRef→EC directo, este paso queda solo referenciado."
fi

# ========= RESUMEN =========
echo "==> Hecho. Archivos:"
ls -lh "$OUTDIR"/uniref_list.txt \
       "$OUTDIR"/uniref90_name_reduced.tsv \
       "$OUTDIR"/uniref90_ko_reduced.tsv \
       "$OUTDIR"/ko_list.txt \
       "$OUTDIR"/ko_name_reduced.tsv \
       "$OUTDIR"/uniref90_level4ec_reduced.tsv

