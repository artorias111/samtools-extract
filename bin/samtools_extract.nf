process create_index {
    input:
    path fasta
    
    output:
    path fasta, emit: indexed_fasta
    path "*.fai", emit: index_file
    
    script:
    """
    samtools faidx ${fasta}
    """
}

process split_coordinates {
    input:
    path coordinates_file
    
    output:
    path "coordinates_parsed.txt", emit: coords_file
    
    script:
    """
    # Ensure the file is properly formatted
    awk -F'\t' 'NF==3 {print \$1"\\t"\$2"\\t"\$3}' ${coordinates_file} > coordinates_parsed.txt
    """
}

process samtools_extract { 
    publishDir 'results', mode: 'copy'
    
    input:
    tuple path(fasta), path(coordinates_file)

    output:
    path "*.fa", emit: extracted_fasta

    script:
    """
    while IFS=\$'\\t' read -r contig start stop; do
        samtools faidx ${fasta} \${contig}:\${start}-\${stop} > \${contig}.\${start}.\${stop}.fa
    done < ${coordinates_file}
    """
}
