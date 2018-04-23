class ShelflistReport < AbstractReport

  register_report

  def headers
    [
      'repository', 'building', 'floor', 'room', 'area', 'location_barcode',
      'coordinate_label_1', 'coordinate_indicator_1',
      'coordinate_label_2', 'coordinate_indicator_2',
      'coordinate_label_3', 'coordinate_indicator_3',
      'location_profile_name', 'identifier', 'title', 'container_type',
      'container_indicator', 'container_barcode', 'container_profile'
    ]
  end

  def processor
    {
      'rec_identifier' => proc{|record| ASUtils.json_parse(record[:rec_identifier] || '[]').compact.join('-')}
    }
  end

  def query

    acc = accessions_query
    res = resources_query

    ds1 = db.fetch(acc, @repo_id)
    ds2 = db.fetch(res, @repo_id)

    ds1.union(ds2)

  end

  def accessions_query

    query = <<-SQL
          SELECT `top_container`.`repo_id` AS tc_repo,
                 `location`.`building` AS loc_building,
                 `location`.`floor` AS loc_floor,
                 `location`.`room` AS loc_room,
                 `location`.`area` AS loc_area,
                 `location`.`barcode` AS loc_barcode,
                 `location`.`coordinate_1_label` AS loc_coordinate_1_label,
                 `location`.`coordinate_1_indicator` AS loc_coordinate_1_indicator,
                 `location`.`coordinate_2_label` AS loc_coordinate_2_label,
                 `location`.`coordinate_2_indicator` AS loc_coordinate_2_indicator,
                 `location`.`coordinate_3_label` AS loc_coordinate_3_label,
                 `location`.`coordinate_3_indicator` AS loc_coordinate_3_indicator,
                 `accession`.`identifier` AS rec_identifier,
                 `accession`.`title` AS rec_title,
                 GetEnumValue(`top_container`.`type_id`) AS tc_type,
                 `top_container`.`indicator` AS tc_ind,
                 `top_container`.`barcode` AS tc_barcode,
                 `container_profile`.`name` AS tc_profile
           FROM   (`top_container_housed_at_rlshp` INNER JOIN `location` ON `top_container_housed_at_rlshp`.`location_id`=`location`.`id`)
            INNER JOIN `top_container` ON `top_container_housed_at_rlshp`.`top_container_id`=`top_container`.`id`
            INNER JOIN `top_container_link_rlshp` ON `top_container_link_rlshp`.`top_container_id`=`top_container`.`id`
            INNER JOIN `top_container_profile_rlshp` ON `top_container_profile_rlshp`.`top_container_id`=`top_container`.`id`
            INNER JOIN `container_profile` ON `container_profile`.`id` = `top_container_profile_rlshp`.`container_profile_id`
            INNER JOIN `sub_container` ON `sub_container`.`id`=`top_container_link_rlshp`.`sub_container_id`
            INNER JOIN `instance` ON `instance`.`id`=`sub_container`.`instance_id`
            INNER JOIN `accession` ON `accession`.`id`=`instance`.`accession_id`
            WHERE `top_container`.`repo_id`= ?
            ORDER BY loc_building, loc_floor, loc_room, loc_area, loc_coordinate_1_label,
                     loc_coordinate_1_indicator, loc_coordinate_2_label,
                     loc_coordinate_2_indicator, loc_coordinate_3_label,
                     loc_coordinate_3_indicator, tc_ind

        SQL

  end
  def resources_query
    query = <<-SQL
          SELECT `top_container`.`repo_id` AS tc_repo,
                 `location`.`building` AS loc_building,
                 `location`.`floor` AS loc_floor,
                 `location`.`room` AS loc_room,
                 `location`.`area` AS loc_area,
                 `location`.`barcode` AS loc_barcode,
                 `location`.`coordinate_1_label` AS loc_coordinate_1_label,
                 `location`.`coordinate_1_indicator` AS loc_coordinate_1_indicator,
                 `location`.`coordinate_2_label` AS loc_coordinate_2_label,
                 `location`.`coordinate_2_indicator` AS loc_coordinate_2_indicator,
                 `location`.`coordinate_3_label` AS loc_coordinate_3_label,
                 `location`.`coordinate_3_indicator` AS loc_coordinate_3_indicator,
                 `resource`.`identifier` AS rec_identifier,
                 `resource`.`title` AS rec_title,
                 GetEnumValue(`top_container`.`type_id`) AS tc_type,
                 `top_container`.`indicator` AS tc_ind,
                 `top_container`.`barcode` AS tc_barcode,
                 `container_profile`.`name` AS tc_profile
           FROM   (`top_container_housed_at_rlshp` INNER JOIN `location` ON `top_container_housed_at_rlshp`.`location_id`=`location`.`id`)
            INNER JOIN `top_container` ON `top_container_housed_at_rlshp`.`top_container_id`=`top_container`.`id`
            INNER JOIN `top_container_link_rlshp` ON `top_container_link_rlshp`.`top_container_id`=`top_container`.`id`
            INNER JOIN `top_container_profile_rlshp` ON `top_container_profile_rlshp`.`top_container_id`=`top_container`.`id`
            INNER JOIN `container_profile` ON `container_profile`.`id` = `top_container_profile_rlshp`.`container_profile_id`
            INNER JOIN `sub_container` ON `sub_container`.`id`=`top_container_link_rlshp`.`sub_container_id`
            INNER JOIN `instance` ON `instance`.`id`=`sub_container`.`instance_id`
            INNER JOIN `resource` ON `resource`.`id`=`instance`.`resource_id`
            WHERE `top_container`.`repo_id`= ?
            ORDER BY loc_building, loc_floor, loc_room, loc_area, loc_coordinate_1_label,
                     loc_coordinate_1_indicator, loc_coordinate_2_label,
                     loc_coordinate_2_indicator, loc_coordinate_3_label,
                     loc_coordinate_3_indicator, tc_ind

        SQL

  end

end
