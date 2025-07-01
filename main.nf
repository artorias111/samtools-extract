// include modules

include { create_index } from './bin/samtools_extract.nf'
include { split_coordinates } from './bin/samtools_extract.nf'
include { samtools_extract } from './bin/samtools_extract.nf'

workflow {
    fasta_ch = channel.fromPath(params.fasta)
    coordinates_list = channel.fromPath(params.labels)

    // Create index for the FASTA file
    create_index(fasta_ch)
    
    // Split coordinates from TSV file
    split_coordinates(coordinates_list)

    // Extract regions using samtools
    samtools_extract(
        create_index.out.indexed_fasta
        .combine(split_coordinates.out.coords_file)
    )
}
