import '../../enums/trash_type.dart';
import '../trash.dart';

class EggTrash extends Trash {
  EggTrash({required super.position})
    : super(trashType: TrashType.compost, spriteSrc: 'trash_objects/egg.png');
}