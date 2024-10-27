import '../../enums/trash_type.dart';
import '../trash.dart';

class PlasticBagTrash extends Trash {
  PlasticBagTrash({required super.position})
    : super(trashType: TrashType.plastic, spriteSrc: 'trash_objects/plastic_bag.png');
}