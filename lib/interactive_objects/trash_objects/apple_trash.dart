import '../../enums/trash_type.dart';
import '../trash.dart';

class AppleTrash extends Trash {
  AppleTrash({required super.position})
    : super(trashType: TrashType.compost, spriteSrc: 'trash_objects/apple.png');
}